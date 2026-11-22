import 'package:flutter/material.dart';

const _bg = Color(0xFF062F2D);
const _green = Color(0xFF0D5148);
const _gold = Color(0xFFD9B66F);
const _cream = Color(0xFFF4F0E6);

class JanazahGuidePage extends StatefulWidget {
  const JanazahGuidePage({super.key});

  @override
  State<JanazahGuidePage> createState() => _JanazahGuidePageState();
}

class _JanazahGuidePageState extends State<JanazahGuidePage> {
  int index = 0;

  static const steps = [
    [
      'Pehli Takbeer aur Sana',
      'Pehli takbeer par haath kaanon tak uthayein. Mard Hanafi tareeqe mein haath naaf ke neeche baandh kar Sana aahista parhein.',
      'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالٰى جَدُّكَ وَجَلَّ ثَنَاؤُكَ وَلَا إِلٰهَ غَيْرُكَ',
      'Subhanak Allahumma wa bihamdika, wa tabarakasmuka, wa ta‘ala jadduka, wa jalla thana’uka, wa la ilaha ghairuk.',
      'اے اللہ! تو پاک ہے اور تیری ہی حمد ہے، تیرا نام بابرکت ہے، تیری شان بلند ہے، تیری ثنا عظیم ہے اور تیرے سوا کوئی معبود نہیں۔',
      'ہاتھ اٹھا کر پھر باندھیں',
    ],
    [
      'Doosri Takbeer aur Durood',
      'Doosri takbeer kahein. Haath dobara na uthayein. Durood-e-Ibrahimi aahista parhein.',
      'اللّٰهُمَّ صَلِّ عَلٰى مُحَمَّدٍ وَّعَلٰى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى إِبْرَاهِيمَ وَعَلٰى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ. اللّٰهُمَّ بَارِكْ عَلٰى مُحَمَّدٍ وَّعَلٰى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى إِبْرَاهِيمَ وَعَلٰى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      'Allahumma salli ‘ala Muhammadin wa ‘ala aali Muhammad, kama sallayta ‘ala Ibrahima wa ‘ala aali Ibrahim, innaka Hamidum Majid. Allahumma barik ‘ala Muhammadin wa ‘ala aali Muhammad, kama barakta ‘ala Ibrahima wa ‘ala aali Ibrahim, innaka Hamidum Majid.',
      'اے اللہ! محمد ﷺ اور آلِ محمد پر رحمت اور برکت نازل فرما، جیسے تو نے ابراہیمؑ اور آلِ ابراہیم پر نازل فرمائی۔ بے شک تو تعریف والا، بزرگی والا ہے۔',
      'ہاتھ بندھے رکھ کر درود پڑھیں',
    ],
    [
      'Teesri Takbeer aur Dua',
      'Teesri takbeer kahein, haath na uthayein. Baligh mayyat ke liye yeh dua aahista parhein.',
      'اللّٰهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا وَشَاهِدِنَا وَغَائِبِنَا وَصَغِيرِنَا وَكَبِيرِنَا وَذَكَرِنَا وَأُنْثَانَا. اللّٰهُمَّ مَنْ أَحْيَيْتَهُ مِنَّا فَأَحْيِهِ عَلَى الْإِسْلَامِ وَمَنْ تَوَفَّيْتَهُ مِنَّا فَتَوَفَّهُ عَلَى الْإِيمَانِ',
      'Allahummaghfir lihayyina wa mayyitina, wa shahidina wa gha’ibina, wa saghirina wa kabirina, wa zakarina wa unthana. Allahumma man ahyaytahu minna fa-ahyihi ‘alal-Islam, wa man tawaffaytahu minna fatawaffahu ‘alal-iman.',
      'اے اللہ! ہمارے زندوں اور فوت شدگان، حاضر اور غائب، چھوٹوں اور بڑوں، مردوں اور عورتوں کی مغفرت فرما۔ ہم میں سے جسے زندہ رکھے اسے اسلام پر زندہ رکھ اور جسے وفات دے اسے ایمان پر وفات دے۔',
      'کھڑے ہو کر میت کے لیے دعا',
    ],
    [
      'Chauthi Takbeer aur Salam',
      'Chauthi takbeer kahein. Is ke baad koi khaas dua nahi. Daayein aur baayein salam pher kar namaz mukammal karein.',
      'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
      'Assalamu ‘alaykum wa rahmatullah.',
      'تم پر سلامتی ہو اور اللہ کی رحمت ہو۔',
      'دائیں اور بائیں سلام پھیریں',
    ],
  ];

  static const icons = [
    Icons.front_hand_outlined,
    Icons.volunteer_activism_outlined,
    Icons.volunteer_activism,
    Icons.west,
  ];

  @override
  Widget build(BuildContext context) {
    final step = steps[index];
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Namaz-e-Janaza'),
        backgroundColor: _bg,
        foregroundColor: _cream,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_green, _bg, Color(0xFF031E20)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _gold.withValues(alpha: .3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اہلِ سنت • فقہِ حنفی',
                    style: TextStyle(
                      color: _gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Namaz-e-Janaza ka asaan tareeqa',
                    style: TextStyle(
                      color: _cream,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Chaar takbeerein. Puri namaz kharay ho kar hoti hai.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
                    decoration: BoxDecoration(
                      color: i <= index ? _gold : Colors.white24,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _gold.withValues(alpha: .3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(icons[index], color: _gold, size: 30),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          step[0],
                          style: const TextStyle(
                            color: _cream,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text(
                        '${index + 1}/4',
                        style: const TextStyle(color: _gold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 118,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _bg.withValues(alpha: .7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icons[index], color: _gold, size: 45),
                        const SizedBox(height: 8),
                        Text(
                          step[5],
                          style: const TextStyle(
                            color: _cream,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _card('Kya karna hai?', step[1], false),
            _card('Arabic', step[2], true, large: true),
            _card('Roman Urdu', step[3], false),
            _card('Urdu tarjuma', step[4], true),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: index == 0 ? null : () => setState(() => index--),
                    style: OutlinedButton.styleFrom(foregroundColor: _gold),
                    child: const Text('Pichla step'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => setState(() => index = index == 3 ? 0 : index + 1),
                    style: FilledButton.styleFrom(
                      backgroundColor: _gold,
                      foregroundColor: _bg,
                    ),
                    child: Text(index == 3 ? 'Dobara dekhein' : 'Agla step'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _gold.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _gold.withValues(alpha: .25)),
              ),
              child: const Text(
                'Yaad rakhein: Janaza ki namaz mein Ruku, Sajda aur Qa‘dah nahi hota. Hanafi tareeqe mein haath sirf pehli takbeer par uthaye jate hain. Chauthi takbeer ke baad salam hota hai.',
                style: TextStyle(color: _cream, height: 1.6),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeh baligh mayyat ke liye taleemi rehnumai hai. Bachay ke janazay aur khaas surat-e-haal ke liye mo‘tabar Sunni Hanafi alim se masla poochhein.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String text, bool rtl, {bool large = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 11),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: _gold, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 9),
          SelectableText(
            text,
            textAlign: rtl ? TextAlign.right : TextAlign.left,
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              color: _cream,
              fontSize: large ? 22 : (rtl ? 18 : 15),
              height: large ? 2 : 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
