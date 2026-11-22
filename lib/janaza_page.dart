import 'package:flutter/material.dart';

const Color _janazaDeep = Color(0xFF062F2D);
const Color _janazaGold = Color(0xFFD9B66F);
const Color _janazaCream = Color(0xFFF4F0E6);

class JanazaPage extends StatelessWidget {
  const JanazaPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _janazaDeep,
        appBar: AppBar(
          title: const Text('Janaza ka Tariqa'),
          backgroundColor: _janazaDeep,
          foregroundColor: _janazaCream,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            const _InfoCard(
              title: 'Namaz-e-Janaza',
              body: 'Yeh farz-e-kifayah hai. Is mein ruku aur sajda nahi hota; '
                  'char takbeerein hoti hain. Neeche aam Hanafi tareeqa diya gaya hai.',
            ),
            const SizedBox(height: 14),
            const _StepCard(
              number: '1',
              title: 'Pehli takbeer',
              body: 'Imam ke saath “Allahu Akbar” kahen aur haath bandh lein. '
                  'Hanafi tareeqe mein pehli takbeer par haath uthaye jate hain. '
                  'Phir Sana parhein:',
              arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَجَلَّ ثَنَاؤُكَ وَلَا إِلَٰهَ غَيْرُكَ',
              translation: 'Subhanak Allahumma wa bihamdika wa tabarakasmuka '
                  'wa ta‘ala jadduka wa jalla thana’uka wa la ilaha ghayruk.',
            ),
            const SizedBox(height: 12),
            const _StepCard(
              number: '2',
              title: 'Doosri takbeer',
              body: 'Doosri takbeer kahen. Hanafi tareeqe mein dobara haath nahi '
                  'uthaye jate. Durood-e-Ibrahimi parhein, jo namaz mein parha jata hai.',
            ),
            const SizedBox(height: 12),
            const _StepCard(
              number: '3',
              title: 'Teesri takbeer',
              body: 'Teesri takbeer ke baad mayyit ke liye maghfirat aur rahmat ki dua karein. '
                  'Yeh mashhoor masnoon dua parhi ja sakti hai:',
              arabic: 'اللَّهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا وَشَاهِدِنَا وَغَائِبِنَا وَصَغِيرِنَا وَكَبِيرِنَا وَذَكَرِنَا وَأُنْثَانَا',
              translation: 'Allahummaghfir lihayyina wa mayyitina wa shahidina '
                  'wa gha’ibina wa saghirina wa kabirina wa dhakarina wa unthana.',
              note: 'Agar dua yaad na ho to Allah Ta‘ala se mayyit ki maghfirat '
                  'aur akhirat ki bhalai ki dua karein.',
            ),
            const SizedBox(height: 12),
            const _StepCard(
              number: '4',
              title: 'Chauthi takbeer aur salam',
              body: 'Chauthi takbeer kahen. Phir imam ke saath salam pher kar namaz mukammal karein.',
            ),
            const SizedBox(height: 14),
            const _InfoCard(
              title: 'Zaroori baatein',
              body: '• Namaz-e-Janaza mein ruku aur sajda nahi hota.\n'
                  '• Imam aur muqtadi khamoshi aur adab ka khayal rakhein.\n'
                  '• Bachche ke janaze ki dua baligh mayyit se mukhtalif hoti hai.\n'
                  '• Mayyit mard ho ya aurat, imam ke kharay hone ki jagah ke bare mein '
                  'fiqhi tafseel milti hai; apni masjid ke imam se seekhein.',
            ),
            const SizedBox(height: 10),
            Text(
              'Taleemi note: Yeh aam Hanafi rehnumai hai. Janaze ke ahkam mein '
              'maslakon ke darmiyan kuch jaiz ikhtilaf ho sakta hai. Amali adaigi '
              'ke liye apne ilaqe ke mustanad imam/alim se tasdeeq karein.',
              style: TextStyle(color: _janazaCream.withOpacity(.65), fontSize: 12, height: 1.5),
            ),
          ],
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _janazaGold.withOpacity(.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: _janazaGold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: _janazaCream, height: 1.55)),
        ]),
      );
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String body;
  final String? arabic;
  final String? translation;
  final String? note;

  const _StepCard({
    required this.number,
    required this.title,
    required this.body,
    this.arabic,
    this.translation,
    this.note,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A403B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _janazaGold.withOpacity(.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: _janazaGold,
              child: Text(number, style: const TextStyle(color: _janazaDeep, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(color: _janazaGold, fontSize: 17, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 11),
          Text(body, style: const TextStyle(color: _janazaCream, height: 1.5)),
          if (arabic != null) ...[
            const SizedBox(height: 13),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(arabic!, textAlign: TextAlign.right,
                  style: const TextStyle(color: _janazaCream, fontSize: 20, height: 1.9)),
            ),
          ],
          if (translation != null) ...[
            const SizedBox(height: 8),
            Text(translation!, style: TextStyle(color: _janazaCream.withOpacity(.75), height: 1.5)),
          ],
          if (note != null) ...[
            const SizedBox(height: 10),
            Text(note!, style: const TextStyle(color: _janazaGold, height: 1.5)),
          ],
        ]),
      );
}
