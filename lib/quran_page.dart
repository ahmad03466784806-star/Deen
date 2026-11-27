import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _qDeep = Color(0xFF062F2D);
const _qGreen = Color(0xFF0A403B);
const _qGold = Color(0xFFD9B66F);
const _qCream = Color(0xFFF4F0E6);

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});
  @override
  State<QuranPage> createState() => _QuranPageState();
}
class _QuranPageState extends State<QuranPage> {
  late Future<List<dynamic>> _surahs = _loadSurahs();
  final _search = TextEditingController();
  Future<List<dynamic>> _loadSurahs() async {
    final response = await http.get(Uri.https('api.alquran.cloud', '/v1/surah'));
    if (response.statusCode != 200) throw Exception('Quran source is temporarily unavailable.');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('Unable to load Surah list.');
    return json['data'] as List<dynamic>;
  }
  @override
  void dispose() { _search.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _qDeep,
    appBar: AppBar(title: const Text('Al-Quran'), backgroundColor: _qDeep, foregroundColor: _qCream),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: TextField(controller: _search, onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: 'Search Surah by name or number', prefixIcon: Icon(Icons.search, color: _qGold))),
      ),
      Expanded(child: FutureBuilder<List<dynamic>>(
        future: _surahs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _qGold));
          if (snapshot.hasError) return _QuranMessage(message: 'Quran data load nahi ho saka.\n\${snapshot.error}', action: 'Retry', onTap: () => setState(() => _surahs = _loadSurahs()));
          final query = _search.text.trim().toLowerCase();
          final list = snapshot.data!.where((item) {
            final s = item as Map<String, dynamic>;
            return query.isEmpty || s['number'].toString() == query ||
              (s['englishName'] as String).toLowerCase().contains(query) ||
              (s['name'] as String).contains(query) ||
              (s['englishNameTranslation'] as String).toLowerCase().contains(query);
          }).toList();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final s = list[index] as Map<String, dynamic>;
              return Card(color: _qGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _qGold.withValues(alpha: .18))),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: _qGold, foregroundColor: _qDeep, child: Text('\${s['number']}')),
                  title: Text('\${s['englishName']}', style: const TextStyle(color: _qCream, fontWeight: FontWeight.bold)),
                  subtitle: Text('\${s['englishNameTranslation']} • \${s['numberOfAyahs']} Ayat', style: const TextStyle(color: Colors.white70)),
                  trailing: Text('\${s['name']}', textDirection: TextDirection.rtl, style: const TextStyle(color: _qGold, fontSize: 21)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuranSurahPage(number: s['number'] as int, name: s['englishName'] as String, arabicName: s['name'] as String))),
                ));
            },
          );
        },
      )),
      const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: Text(
        'Text and translations are retrieved from AlQuran Cloud. Translation wording belongs to its named translator/edition.',
        textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
    ]),
  );
}

class QuranSurahPage extends StatefulWidget {
  final int number;
  final String name;
  final String arabicName;
  const QuranSurahPage({super.key, required this.number, required this.name, required this.arabicName});
  @override
  State<QuranSurahPage> createState() => _QuranSurahPageState();
}
class _QuranSurahPageState extends State<QuranSurahPage> {
  late Future<List<dynamic>> _verses = _loadVerses();
  Future<List<dynamic>> _loadVerses() async {
    final path = '/v1/surah/\${widget.number}/editions/quran-uthmani,ur.jalandhry,en.sahih';
    final response = await http.get(Uri.https('api.alquran.cloud', path));
    if (response.statusCode != 200) throw Exception('Unable to retrieve this Surah.');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('Quran source returned an error.');
    final editions = json['data'] as List<dynamic>;
    if (editions.length < 3) throw Exception('Required translation editions were not returned.');
    final arabic = editions[0]['ayahs'] as List<dynamic>;
    final urdu = editions[1]['ayahs'] as List<dynamic>;
    final english = editions[2]['ayahs'] as List<dynamic>;
    return List.generate(arabic.length, (i) => {
      'number': arabic[i]['numberInSurah'], 'arabic': arabic[i]['text'],
      'urdu': urdu[i]['text'], 'english': english[i]['text'],
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _qDeep,
    appBar: AppBar(title: Text(widget.name), backgroundColor: _qDeep, foregroundColor: _qCream,
      actions: [IconButton(tooltip: 'Reload', onPressed: () => setState(() => _verses = _loadVerses()), icon: const Icon(Icons.refresh))]),
    body: FutureBuilder<List<dynamic>>(
      future: _verses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _qGold));
        if (snapshot.hasError) return _QuranMessage(message: 'Ayat load nahi ho sakin.\n\${snapshot.error}', action: 'Retry', onTap: () => setState(() => _verses = _loadVerses()));
        final verses = snapshot.data!;
        return ListView(padding: const EdgeInsets.all(14), children: [
          Card(color: _qGreen, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
            Text(widget.arabicName, textDirection: TextDirection.rtl, style: const TextStyle(color: _qGold, fontSize: 30)),
            const SizedBox(height: 5), Text('\${widget.name} • Surah \${widget.number}', style: const TextStyle(color: _qCream)),
          ]))),
          for (final verse in verses)
            Card(color: _qGreen, margin: const EdgeInsets.only(top: 10),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Align(alignment: Alignment.centerLeft, child: CircleAvatar(radius: 15, backgroundColor: _qGold, foregroundColor: _qDeep, child: Text('\${verse['number']}'))),
                const SizedBox(height: 14),
                SelectableText(verse['arabic'] as String, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: const TextStyle(color: _qCream, fontSize: 25, height: 2)),
                const Divider(color: Colors.white24, height: 26),
                const Text('اردو ترجمہ — جالندھری', textDirection: TextDirection.rtl, style: TextStyle(color: _qGold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                SelectableText(verse['urdu'] as String, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: const TextStyle(color: _qCream, fontSize: 17, height: 1.8)),
                const SizedBox(height: 12),
                const Text('English translation — Sahih International', style: TextStyle(color: _qGold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                SelectableText(verse['english'] as String, style: const TextStyle(color: _qCream, height: 1.6)),
              ]))),
        ]);
      },
    ),
  );
}
class _QuranMessage extends StatelessWidget {
  final String message;
  final String action;
  final VoidCallback onTap;
  const _QuranMessage({required this.message, required this.action, required this.onTap});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.menu_book_outlined, color: _qGold, size: 56), const SizedBox(height: 12),
    Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _qCream)),
    const SizedBox(height: 14), FilledButton(onPressed: onTap, child: Text(action)),
  ])));
}
