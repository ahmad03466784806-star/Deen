import 'package:flutter/material.dart';

const Color _deep = Color(0xFF062F2D);
const Color _gold = Color(0xFFD9B66F);
const Color _cream = Color(0xFFF4F0E6);

class DuasPage extends StatelessWidget {
  const DuasPage({super.key});

  static const duas = <_DuaItem>[
    _DuaItem(
      title: 'Duniya aur Aakhirat ki bhalai',
      arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      transliteration: 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhaban-nar.',
      meaning: 'Aye hamare Rabb! Humein duniya mein bhalai de aur aakhirat mein bhi bhalai de, aur humein aag ke azaab se bacha.',
      source: 'Surah Al-Baqarah 2:201',
    ),
    _DuaItem(
      title: 'Ilm mein izafa',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni ilma.',
      meaning: 'Aye mere Rabb! Mere ilm mein izafa farma.',
      source: 'Surah Taha 20:114',
    ),
    _DuaItem(
      title: 'Apne aur walidain ke liye maghfirat',
      arabic: 'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
      transliteration: 'Rabbanaghfir li wa liwalidayya wa lil-mu’minina yawma yaqumul-hisab.',
      meaning: 'Aye hamare Rabb! Mujhe, mere walidain ko aur momineen ko hisaab ke din bakhsh de.',
      source: 'Surah Ibrahim 14:41',
    ),
    _DuaItem(
      title: 'Pareshani aur tangi mein dua',
      arabic: 'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      transliteration: 'La ilaha illa Anta, subhanaka inni kuntu minaz-zalimin.',
      meaning: 'Tere siwa koi mabood nahi; Tu paak hai. Beshak mujh se hi kotahi hui.',
      source: 'Surah Al-Anbiya 21:87',
    ),
    _DuaItem(
      title: 'Hidayat aur taqwa',
      arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      transliteration: 'Ihdinas-siratal-mustaqim.',
      meaning: 'Humein seedha raasta dikha.',
      source: 'Surah Al-Fatihah 1:6',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _deep,
        appBar: AppBar(
          title: const Text('Duas & Azkar'),
          backgroundColor: _deep,
          foregroundColor: _cream,
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Quran se muntakhib duaein',
              style: TextStyle(color: _gold, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Arabic matn, Roman transliteration aur asaan mafhoom ke saath.',
              style: TextStyle(color: _cream.withOpacity(.7)),
            ),
            const SizedBox(height: 16),
            for (final dua in duas) ...[
              _DuaCard(dua: dua),
              const SizedBox(height: 12),
            ],
            Text(
              'Note: Roman transliteration sirf madad ke liye hai. Tajweed aur talaffuz seekhne ke liye Arabic matn kisi mustanad qari se parhein.',
              style: TextStyle(color: _cream.withOpacity(.6), fontSize: 12, height: 1.5),
            ),
          ],
        ),
      );
}

class _DuaItem {
  final String title, arabic, transliteration, meaning, source;
  const _DuaItem({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.source,
  });
}

class _DuaCard extends StatelessWidget {
  final _DuaItem dua;
  const _DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A403B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _gold.withOpacity(.22)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dua.title, style: const TextStyle(color: _gold, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(dua.arabic, textAlign: TextAlign.right,
                style: const TextStyle(color: _cream, fontSize: 23, height: 1.9)),
          ),
          const SizedBox(height: 10),
          Text(dua.transliteration, style: TextStyle(color: _cream.withOpacity(.78), height: 1.5)),
          const SizedBox(height: 8),
          Text(dua.meaning, style: const TextStyle(color: _cream, height: 1.5)),
          const SizedBox(height: 10),
          Text(dua.source, style: const TextStyle(color: _gold, fontSize: 12)),
        ]),
      );
}
