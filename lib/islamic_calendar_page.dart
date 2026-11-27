import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _cDeep = Color(0xFF062F2D);
const _cGreen = Color(0xFF0A403B);
const _cGold = Color(0xFFD9B66F);
const _cCream = Color(0xFFF4F0E6);

class IslamicCalendarPage extends StatefulWidget {
  const IslamicCalendarPage({super.key});
  @override
  State<IslamicCalendarPage> createState() => _IslamicCalendarPageState();
}
class _IslamicCalendarPageState extends State<IslamicCalendarPage> {
  final _city = TextEditingController();
  final _country = TextEditingController(text: 'Pakistan');
  late DateTime _month = DateTime.now();
  bool _loading = false;
  String? _error;
  List<dynamic> _days = [];

  Future<void> _loadMonth() async {
    if (_city.text.trim().isEmpty || _country.text.trim().isEmpty) {
      setState(() => _error = 'Enter your city and country to load the local Hijri calendar.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final uri = Uri.https('api.aladhan.com', '/v1/calendarByCity/\${_month.year}/\${_month.month}', {
        'city': _city.text.trim(),
        'country': _country.text.trim(),
        'method': '1',
      });
      final response = await http.get(uri);
      if (response.statusCode != 200) throw Exception('Calendar service returned \${response.statusCode}.');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] != 200) throw Exception('Calendar data is unavailable.');
      if (!mounted) return;
      setState(() => _days = json['data'] as List<dynamic>);
    } catch (e) {
      if (mounted) setState(() => _error = 'Calendar load nahi ho saka. $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta, 1);
      _days = [];
      _error = null;
    });
    if (_city.text.trim().isNotEmpty) _loadMonth();
  }

  @override
  void dispose() { _city.dispose(); _country.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _cDeep,
    appBar: AppBar(title: const Text('Islamic Calendar'), backgroundColor: _cDeep, foregroundColor: _cCream),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Local Hijri calendar', style: TextStyle(color: _cGold, fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('Hijri dates can vary by local moon sighting. Confirm important Islamic dates with your local recognised authority.',
        style: TextStyle(color: Colors.white70, height: 1.5)),
      const SizedBox(height: 14),
      TextField(controller: _city, style: const TextStyle(color: _cCream), decoration: const InputDecoration(labelText: 'City', hintText: 'e.g. Lahore')),
      const SizedBox(height: 10),
      TextField(controller: _country, style: const TextStyle(color: _cCream), decoration: const InputDecoration(labelText: 'Country', hintText: 'Pakistan')),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _loading ? null : _loadMonth,
        icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.calendar_month),
        label: Text(_loading ? 'Loading…' : 'Load calendar'),
        style: FilledButton.styleFrom(backgroundColor: _cGold, foregroundColor: _cDeep),
      ),
      const SizedBox(height: 18),
      Row(children: [
        IconButton(onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left, color: _cGold)),
        Expanded(child: Text('\${_month.year}-\${_month.month.toString().padLeft(2, '0')}',
          textAlign: TextAlign.center, style: const TextStyle(color: _cCream, fontWeight: FontWeight.bold, fontSize: 18))),
        IconButton(onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right, color: _cGold)),
      ]),
      if (_error != null) Padding(padding: const EdgeInsets.all(8), child: Text(_error!, style: const TextStyle(color: Colors.orangeAccent))),
      for (final item in _days)
        Card(
          color: _cGreen,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: _cGold, foregroundColor: _cDeep,
              child: Text('\${item['date']['gregorian']['day']}')),
            title: Text('\${item['date']['hijri']['day']} \${item['date']['hijri']['month']['en']} \${item['date']['hijri']['year']} AH',
              style: const TextStyle(color: _cGold, fontWeight: FontWeight.bold)),
            subtitle: Text('\${item['date']['gregorian']['weekday']['en']}, \${item['date']['gregorian']['month']['en']} \${item['date']['gregorian']['day']}',
              style: const TextStyle(color: _cCream)),
            trailing: (item['date']['hijri']['holidays'] as List?)?.isNotEmpty == true
              ? const Icon(Icons.star, color: _cGold) : null,
          ),
        ),
      if (_days.isNotEmpty)
        const Padding(padding: EdgeInsets.only(top: 8), child: Text(
          'Calendar data: AlAdhan. Local moon-sighting announcements may differ by one or more days.',
          style: TextStyle(color: Colors.white54, fontSize: 11))),
    ]),
  );
}
