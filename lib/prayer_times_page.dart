import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _pDeep = Color(0xFF062F2D);
const _pGreen = Color(0xFF0A403B);
const _pGold = Color(0xFFD9B66F);
const _pCream = Color(0xFFF4F0E6);

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});
  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}
class _PrayerTimesPageState extends State<PrayerTimesPage> {
  final _city = TextEditingController();
  final _country = TextEditingController(text: 'Pakistan');
  int _method = 1;
  int _school = 1;
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _times;
  String? _date;
  static const _prayers = <(String, IconData)>[
    ('Fajr', Icons.nights_stay_outlined), ('Sunrise', Icons.wb_twilight),
    ('Dhuhr', Icons.wb_sunny_outlined), ('Asr', Icons.sunny),
    ('Maghrib', Icons.wb_twilight), ('Isha', Icons.dark_mode_outlined),
  ];
  Future<void> _fetch() async {
    final city = _city.text.trim();
    final country = _country.text.trim();
    if (city.isEmpty || country.isEmpty) { setState(() => _error = 'Please enter your city and country first.'); return; }
    setState(() { _loading = true; _error = null; _times = null; });
    try {
      final now = DateTime.now();
      final date = '\${now.day.toString().padLeft(2, '0')}-\${now.month.toString().padLeft(2, '0')}-\${now.year}';
      final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity/$date', {
        'city': city, 'country': country, 'method': '$_method', 'school': '$_school',
      });
      final response = await http.get(uri);
      if (response.statusCode != 200) throw Exception('Prayer-time service returned \${response.statusCode}.');
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] != 200) throw Exception(body['data']?['message'] ?? 'Could not calculate prayer times.');
      final data = body['data'] as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _times = Map<String, dynamic>.from(data['timings'] as Map);
        _date = '\${data['date']['readable']} • \${data['date']['hijri']['date']} AH';
      });
    } catch (e) {
      if (mounted) setState(() => _error = 'Prayer times load nahi ho sake. $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  @override
  void dispose() { _city.dispose(); _country.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _pDeep,
    appBar: AppBar(title: const Text('Prayer Times'), backgroundColor: _pDeep, foregroundColor: _pCream),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Apni location aur calculation settings select karein.', style: TextStyle(color: _pCream, fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      TextField(controller: _city, style: const TextStyle(color: _pCream), decoration: const InputDecoration(labelText: 'City', hintText: 'e.g. Lahore')),
      const SizedBox(height: 10),
      TextField(controller: _country, style: const TextStyle(color: _pCream), decoration: const InputDecoration(labelText: 'Country', hintText: 'e.g. Pakistan')),
      const SizedBox(height: 10),
      DropdownButtonFormField<int>(value: _method, dropdownColor: _pGreen, decoration: const InputDecoration(labelText: 'Calculation method'),
        items: const [
          DropdownMenuItem(value: 1, child: Text('University of Islamic Sciences, Karachi')),
          DropdownMenuItem(value: 2, child: Text('ISNA')),
          DropdownMenuItem(value: 3, child: Text('Muslim World League')),
          DropdownMenuItem(value: 4, child: Text('Umm al-Qura')),
          DropdownMenuItem(value: 5, child: Text('Egyptian General Authority')),
        ], onChanged: (v) => setState(() => _method = v ?? 1)),
      const SizedBox(height: 10),
      DropdownButtonFormField<int>(value: _school, dropdownColor: _pGreen, decoration: const InputDecoration(labelText: 'Asr juristic method'),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Hanafi')),
          DropdownMenuItem(value: 0, child: Text('Shafi / Standard')),
        ], onChanged: (v) => setState(() => _school = v ?? 1)),
      const SizedBox(height: 14),
      FilledButton.icon(
        onPressed: _loading ? null : _fetch,
        icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.calculate_outlined),
        label: Text(_loading ? 'Loading…' : 'Calculate today’s times'),
        style: FilledButton.styleFrom(backgroundColor: _pGold, foregroundColor: _pDeep),
      ),
      if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.orangeAccent))],
      if (_times != null) ...[
        const SizedBox(height: 18),
        Card(color: _pGreen, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Today’s prayer schedule', style: TextStyle(color: _pGold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), Text(_date ?? '', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          for (final prayer in _prayers)
            ListTile(contentPadding: EdgeInsets.zero, leading: Icon(prayer.$2, color: _pGold),
              title: Text(prayer.$1, style: const TextStyle(color: _pCream)),
              trailing: Text('\${_times![prayer.$1] ?? '—'}', style: const TextStyle(color: _pGold, fontWeight: FontWeight.bold, fontSize: 16))),
        ]))),
        const SizedBox(height: 10),
        const Text('Times are retrieved from AlAdhan and depend on the selected city, calculation method and Asr school. Confirm local mosque timings where needed. Alarm scheduling is a separate feature and is not enabled by this screen.',
          style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5)),
      ],
    ]),
  );
}
