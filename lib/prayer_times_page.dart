import 'package:flutter/material.dart';
import 'prayer_times_service.dart';

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
  final _service = PrayerTimesService.instance;
  final _city = TextEditingController(text: 'Lahore');
  final _country = TextEditingController(text: 'Pakistan');
  late int _method;
  late int _school;

  static const _prayers = <(String, IconData)>[
    ('Fajr', Icons.nights_stay_outlined),
    ('Sunrise', Icons.wb_twilight),
    ('Dhuhr', Icons.wb_sunny_outlined),
    ('Asr', Icons.sunny),
    ('Maghrib', Icons.wb_twilight),
    ('Isha', Icons.dark_mode_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _method = _service.method;
    _school = _service.school;
    _service.addListener(_refresh);
    _service.initialize();
  }

  void _refresh() {
    if (mounted) setState(() {
      _method = _service.method;
      _school = _service.school;
    });
  }

  Future<void> _saveSettings() async {
    await _service.saveCalculationSettings(newMethod: _method, newSchool: _school);
    if (_service.locationLabel.contains(',')) {
      await _service.fetchByCity(_city.text, _country.text);
    } else {
      await _service.useCurrentLocation();
    }
  }

  @override
  void dispose() {
    _service.removeListener(_refresh);
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _pDeep,
    appBar: AppBar(title: const Text('Prayer Times'), backgroundColor: _pDeep, foregroundColor: _pCream),
    body: AnimatedBuilder(
      animation: _service,
      builder: (context, _) => ListView(padding: const EdgeInsets.all(18), children: [
        const Text('Prayer schedule for your location', style: TextStyle(color: _pCream, fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(_service.locationLabel, style: const TextStyle(color: _pGold)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _service.loading ? null : _service.useCurrentLocation,
          icon: const Icon(Icons.my_location),
          label: const Text('Use my current location'),
          style: OutlinedButton.styleFrom(foregroundColor: _pGold, side: const BorderSide(color: _pGold)),
        ),
        const SizedBox(height: 14),
        const Text('Or enter city manually', style: TextStyle(color: _pCream, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(controller: _city, style: const TextStyle(color: _pCream), decoration: const InputDecoration(labelText: 'City', hintText: 'e.g. Lahore')),
        const SizedBox(height: 10),
        TextField(controller: _country, style: const TextStyle(color: _pCream), decoration: const InputDecoration(labelText: 'Country', hintText: 'e.g. Pakistan')),
        const SizedBox(height: 10),
        DropdownButtonFormField<int>(
          value: _method,
          dropdownColor: _pGreen,
          decoration: const InputDecoration(labelText: 'Calculation method'),
          items: const [
            DropdownMenuItem(value: 1, child: Text('University of Islamic Sciences, Karachi')),
            DropdownMenuItem(value: 2, child: Text('ISNA')),
            DropdownMenuItem(value: 3, child: Text('Muslim World League')),
            DropdownMenuItem(value: 4, child: Text('Umm al-Qura')),
            DropdownMenuItem(value: 5, child: Text('Egyptian General Authority')),
          ],
          onChanged: (v) => setState(() => _method = v ?? 1),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int>(
          value: _school,
          dropdownColor: _pGreen,
          decoration: const InputDecoration(labelText: 'Asr juristic method'),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Hanafi')),
            DropdownMenuItem(value: 0, child: Text('Shafi / Standard')),
          ],
          onChanged: (v) => setState(() => _school = v ?? 1),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _service.loading ? null : () async {
            await _service.saveCalculationSettings(newMethod: _method, newSchool: _school);
            await _service.fetchByCity(_city.text, _country.text);
          },
          icon: const Icon(Icons.calculate_outlined),
          label: const Text('Save settings & calculate'),
          style: FilledButton.styleFrom(backgroundColor: _pGold, foregroundColor: _pDeep),
        ),
        if (_service.loading) const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator(color: _pGold)),
        ),
        if (_service.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_service.errorMessage!, style: const TextStyle(color: Colors.orangeAccent)),
          ),
        if (_service.timings != null) ...[
          const SizedBox(height: 18),
          Card(
            color: _pGreen,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Today’s prayer schedule', style: TextStyle(color: _pGold, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_service.hijriDate ?? '', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                for (final prayer in _prayers)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(prayer.$2, color: _pGold),
                    title: Text(prayer.$1, style: const TextStyle(color: _pCream)),
                    trailing: Text('${_service.timings![prayer.$1] ?? '—'}', style: const TextStyle(color: _pGold, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Times are retrieved from AlAdhan. Karachi calculation method and Hanafi Asr are selected by default. Confirm local mosque timings where needed. Prayer alarms are not yet enabled.',
            style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5),
          ),
        ],
      ]),
    ),
  );
}
