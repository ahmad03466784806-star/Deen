import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  int? _lastSurah;
  int? _lastAyah;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lastSurah = prefs.getInt('quran_last_surah');
      _lastAyah = prefs.getInt('quran_last_ayah');
    });
  }

  Future<List<dynamic>> _loadSurahs() async {
    final response = await http
        .get(Uri.https('api.alquran.cloud', '/v1/surah'))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Quran source is temporarily unavailable.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('Unable to load Surah list.');
    return json['data'] as List<dynamic>;
  }

  void _openSurah(Map<String, dynamic> surah, {int startAyah = 1}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuranSurahPage(
          number: surah['number'] as int,
          name: surah['englishName'] as String,
          arabicName: surah['name'] as String,
          startAyah: startAyah,
        ),
      ),
    ).then((_) => _loadLastRead());
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _qDeep,
        appBar: AppBar(
          title: const Text('Al-Quran Majeed'),
          backgroundColor: _qDeep,
          foregroundColor: _qCream,
        ),
        body: Column(
          children: [
            if (_lastSurah != null)
              FutureBuilder<List<dynamic>>(
                future: _surahs,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final matches = snapshot.data!
                      .where((s) => s['number'] == _lastSurah)
                      .toList();
                  if (matches.isEmpty) return const SizedBox.shrink();
                  final s = matches.first as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Card(
                      color: _qGreen,
                      child: ListTile(
                        leading: const Icon(Icons.bookmark, color: _qGold),
                        title: const Text('Continue reading',
                            style: TextStyle(
                                color: _qCream, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${s['englishName']} • Ayah ${_lastAyah ?? 1}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward, color: _qGold),
                        onTap: () =>
                            _openSurah(s, startAyah: _lastAyah ?? 1),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: _qCream),
                decoration: const InputDecoration(
                  hintText: 'Search Surah by name or number',
                  prefixIcon: Icon(Icons.search, color: _qGold),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _surahs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: _qGold));
                  }
                  if (snapshot.hasError) {
                    return _QuranMessage(
                      message:
                          'Quran data load nahi ho saka.\n${snapshot.error}',
                      action: 'Retry',
                      onTap: () =>
                          setState(() => _surahs = _loadSurahs()),
                    );
                  }
                  final query = _search.text.trim().toLowerCase();
                  final list = snapshot.data!.where((item) {
                    final s = item as Map<String, dynamic>;
                    return query.isEmpty ||
                        s['number'].toString() == query ||
                        (s['englishName'] as String)
                            .toLowerCase()
                            .contains(query) ||
                        (s['name'] as String).contains(query) ||
                        (s['englishNameTranslation'] as String)
                            .toLowerCase()
                            .contains(query);
                  }).toList();
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = list[index] as Map<String, dynamic>;
                      return Card(
                        color: _qGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: _qGold.withValues(alpha: .18)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _qGold,
                            foregroundColor: _qDeep,
                            child: Text('${s['number']}'),
                          ),
                          title: Text(
                            '${s['englishName']}',
                            style: const TextStyle(
                                color: _qCream, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${s['englishNameTranslation']} • ${s['numberOfAyahs']} Ayat',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            '${s['name']}',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                color: _qGold, fontSize: 21),
                          ),
                          onTap: () => _openSurah(s),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Arabic text: Quran Uthmani • Urdu translation: Fateh Muhammad Jalandhry • English translation: Sahih International. Text and audio are provided by AlQuran Cloud.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
          ],
        ),
      );
}

class QuranSurahPage extends StatefulWidget {
  final int number;
  final String name;
  final String arabicName;
  final int startAyah;

  const QuranSurahPage({
    super.key,
    required this.number,
    required this.name,
    required this.arabicName,
    this.startAyah = 1,
  });

  @override
  State<QuranSurahPage> createState() => _QuranSurahPageState();
}

class _QuranSurahPageState extends State<QuranSurahPage> {
  late Future<List<dynamic>> _verses = _loadVerses();
  final AudioPlayer _player = AudioPlayer();
  final Set<int> _bookmarks = {};
  double _arabicSize = 27;
  double _translationSize = 17;
  bool _showUrdu = true;
  bool _showEnglish = true;
  int? _playingAyah;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() {
        _playingAyah = null;
        _isPlaying = false;
      });
    });
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _bookmarks.addAll(
        prefs.getStringList('quran_bookmarks')?.map(int.parse) ?? []));
  }

  Future<List<dynamic>> _loadVerses() async {
    final path =
        '/v1/surah/${widget.number}/editions/quran-uthmani,ur.jalandhry,en.sahih';
    final response = await http
        .get(Uri.https('api.alquran.cloud', path))
        .timeout(const Duration(seconds: 25));
    if (response.statusCode != 200) {
      throw Exception('Unable to retrieve this Surah.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) throw Exception('Quran source returned an error.');
    final editions = json['data'] as List<dynamic>;
    if (editions.length < 3) {
      throw Exception('Required translation editions were not returned.');
    }
    final arabic = editions[0]['ayahs'] as List<dynamic>;
    final urdu = editions[1]['ayahs'] as List<dynamic>;
    final english = editions[2]['ayahs'] as List<dynamic>;
    if (arabic.length != urdu.length || arabic.length != english.length) {
      throw Exception('The Arabic and translation verse counts do not match.');
    }
    return List.generate(
      arabic.length,
      (i) => {
        'number': arabic[i]['numberInSurah'],
        'globalNumber': arabic[i]['number'],
        'arabic': arabic[i]['text'],
        'urdu': urdu[i]['text'],
        'english': english[i]['text'],
      },
    );
  }

  Future<void> _saveLastRead(int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quran_last_surah', widget.number);
    await prefs.setInt('quran_last_ayah', ayah);
  }

  Future<void> _toggleBookmark(int globalNumber) async {
    setState(() {
      if (!_bookmarks.add(globalNumber)) {
        _bookmarks.remove(globalNumber);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'quran_bookmarks', _bookmarks.map((e) => e.toString()).toList());
  }

  Future<void> _playAyah(int globalNumber) async {
    try {
      if (_playingAyah == globalNumber && _isPlaying) {
        await _player.pause();
        if (mounted) setState(() => _isPlaying = false);
        return;
      }
      if (_playingAyah == globalNumber) {
        await _player.resume();
      } else {
        final url =
            'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalNumber.mp3';
        await _player.play(UrlSource(url));
      }
      if (mounted) setState(() {
        _playingAyah = globalNumber;
        _isPlaying = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tilawat play nahi ho saki: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _qDeep,
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: _qDeep,
          foregroundColor: _qCream,
          actions: [
            IconButton(
              tooltip: 'Text size',
              onPressed: _showTextSettings,
              icon: const Icon(Icons.text_fields),
            ),
            IconButton(
              tooltip: 'Reload',
              onPressed: () =>
                  setState(() => _verses = _loadVerses()),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _verses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: _qGold));
            }
            if (snapshot.hasError) {
              return _QuranMessage(
                message: 'Ayat load nahi ho sakin.\n${snapshot.error}',
                action: 'Retry',
                onTap: () => setState(() => _verses = _loadVerses()),
              );
            }
            final verses = snapshot.data!;
            return Column(
              children: [
                _translationControls(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      Card(
                        color: _qGreen,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Text(
                                widget.arabicName,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    color: _qGold, fontSize: 30),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${widget.name} • Surah ${widget.number}',
                                style: const TextStyle(color: _qCream),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Reciter: Mishary Rashid Alafasy',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (final verse in verses.where((v) =>
                          (v['number'] as int) >= widget.startAyah))
                        _verseCard(verse as Map<String, dynamic>),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _translationControls() => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
        child: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('اردو'),
              selected: _showUrdu,
              onSelected: (v) => setState(() => _showUrdu = v),
              selectedColor: _qGold,
            ),
            FilterChip(
              label: const Text('English'),
              selected: _showEnglish,
              onSelected: (v) => setState(() => _showEnglish = v),
              selectedColor: _qGold,
            ),
          ],
        ),
      );

  Widget _verseCard(Map<String, dynamic> verse) {
    final globalNumber = verse['globalNumber'] as int;
    final ayahNumber = verse['number'] as int;
    final isBookmarked = _bookmarks.contains(globalNumber);
    final isCurrent = _playingAyah == globalNumber;
    return Card(
      color: _qGreen,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: _qGold,
                  foregroundColor: _qDeep,
                  child: Text('$ayahNumber'),
                ),
                const Spacer(),
                IconButton(
                  tooltip: isCurrent && _isPlaying ? 'Pause ayah' : 'Play ayah',
                  onPressed: () => _playAyah(globalNumber),
                  icon: Icon(
                    isCurrent && _isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: _qGold,
                    size: 28,
                  ),
                ),
                IconButton(
                  tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark ayah',
                  onPressed: () => _toggleBookmark(globalNumber),
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: _qGold,
                  ),
                ),
                IconButton(
                  tooltip: 'Copy ayah',
                  onPressed: () async {
                    final text = '${verse['arabic']}\n\n'
                        '${verse['urdu']}\n\n${verse['english']}';
                    await Clipboard.setData(ClipboardData(text: text));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ayah copied')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy, color: _qGold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(
              verse['arabic'] as String,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: _qCream, fontSize: _arabicSize, height: 2),
            ),
            if (_showUrdu) ...[
              const Divider(color: Colors.white24, height: 26),
              const Text(
                'اردو ترجمہ — فتح محمد جالندھری',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: _qGold, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SelectableText(
                verse['urdu'] as String,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: _qCream, fontSize: _translationSize, height: 1.8),
              ),
            ],
            if (_showEnglish) ...[
              const SizedBox(height: 12),
              const Text(
                'English translation — Sahih International',
                style: TextStyle(color: _qGold, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SelectableText(
                verse['english'] as String,
                style: TextStyle(
                    color: _qCream, fontSize: _translationSize, height: 1.6),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await _saveLastRead(ayahNumber);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Reading position saved: ${widget.name} $ayahNumber')),
                    );
                  }
                },
                child: const Text('Save reading position',
                    style: TextStyle(color: _qGold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _qGreen,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Reading text size',
                  style: TextStyle(
                      color: _qCream,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Arabic text',
                  style: TextStyle(color: _qCream)),
              Slider(
                value: _arabicSize,
                min: 20,
                max: 42,
                activeColor: _qGold,
                onChanged: (v) {
                  setState(() => _arabicSize = v);
                  setSheetState(() {});
                },
              ),
              const Text('Translation text',
                  style: TextStyle(color: _qCream)),
              Slider(
                value: _translationSize,
                min: 14,
                max: 28,
                activeColor: _qGold,
                onChanged: (v) {
                  setState(() => _translationSize = v);
                  setSheetState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuranMessage extends StatelessWidget {
  final String message;
  final String action;
  final VoidCallback onTap;

  const _QuranMessage({
    required this.message,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book_outlined,
                  color: _qGold, size: 56),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _qCream),
              ),
              const SizedBox(height: 14),
              FilledButton(onPressed: onTap, child: Text(action)),
            ],
          ),
        ),
      );
}
