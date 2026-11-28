import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimesService extends ChangeNotifier {
  PrayerTimesService._();
  static final PrayerTimesService instance = PrayerTimesService._();

  Map<String, dynamic>? timings;
  String? hijriDate;
  String locationLabel = 'Location not set';
  String? errorMessage;
  bool loading = false;
  int method = 1;
  int school = 1;
  bool _initialized = false;

  static const prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    final prefs = await SharedPreferences.getInstance();
    method = prefs.getInt('prayer_method') ?? 1;
    school = prefs.getInt('prayer_school') ?? 1;
    final lat = prefs.getDouble('prayer_latitude');
    final lon = prefs.getDouble('prayer_longitude');
    final city = prefs.getString('prayer_city');
    final country = prefs.getString('prayer_country');
    if (lat != null && lon != null) {
      await fetchByCoordinates(lat, lon, label: 'Saved location');
    } else if (city != null && country != null) {
      await fetchByCity(city, country);
    }
    await useCurrentLocation();
  }

  Future<void> saveCalculationSettings({int? newMethod, int? newSchool}) async {
    if (newMethod != null) method = newMethod;
    if (newSchool != null) school = newSchool;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('prayer_method', method);
    await prefs.setInt('prayer_school', school);
    notifyListeners();
  }

  Future<void> useCurrentLocation() async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) throw Exception('Location services are turned off. Enter your city manually.');
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission was not granted. You can enter your city manually.');
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('prayer_latitude', position.latitude);
      await prefs.setDouble('prayer_longitude', position.longitude);
      await prefs.remove('prayer_city');
      await prefs.remove('prayer_country');
      await fetchByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByCity(String city, String country) async {
    final cleanCity = city.trim();
    final cleanCountry = country.trim();
    if (cleanCity.isEmpty || cleanCountry.isEmpty) {
      errorMessage = 'Please enter both city and country.';
      notifyListeners();
      return;
    }
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final now = DateTime.now();
      final date = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity/$date', {
        'city': cleanCity, 'country': cleanCountry,
        'method': '$method', 'school': '$school',
      });
      await _load(uri, label: '$cleanCity, $cleanCountry');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('prayer_city', cleanCity);
      await prefs.setString('prayer_country', cleanCountry);
      await prefs.remove('prayer_latitude');
      await prefs.remove('prayer_longitude');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByCoordinates(double latitude, double longitude, {String label = 'Current location'}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final uri = Uri.https('api.aladhan.com', '/v1/timings/$timestamp', {
        'latitude': '$latitude', 'longitude': '$longitude',
        'method': '$method', 'school': '$school',
      });
      await _load(uri, label: label);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _load(Uri uri, {required String label}) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) throw Exception('Prayer-time service returned HTTP ${response.statusCode}.');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['code'] != 200) throw Exception('Prayer-time service could not calculate the schedule.');
    final data = body['data'] as Map<String, dynamic>;
    timings = Map<String, dynamic>.from(data['timings'] as Map);
    hijriDate = '${data['date']['hijri']['date']} AH';
    locationLabel = label;
  }
}
