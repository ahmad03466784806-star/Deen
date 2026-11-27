import 'package:flutter/material.dart';

const _deep = Color(0xFF062F2D);
const _deep2 = Color(0xFF0A403B);
const _gold = Color(0xFFD9B66F);
const _cream = Color(0xFFF4F0E6);

class KalimaatPage extends StatelessWidget {
  const KalimaatPage({super.key});

  static const _items = <_TextItem>[
    _TextItem('پہلا کلمہ طیب', 'First Kalima — Tayyibah',
      'لَا إِلٰهَ إِلَّا اللّٰهُ مُحَمَّدٌ رَّسُولُ اللّٰهِ',
      'اللہ کے سوا کوئی معبود نہیں، محمد ﷺ اللہ کے رسول ہیں۔',
      'There is no deity except Allah; Muhammad ﷺ is the Messenger of Allah.'),
    _TextItem('دوسرا کلمہ شہادت', 'Second Kalima — Shahadah',
      'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں؛ اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔',
      'I bear witness that none is worthy of worship except Allah alone, without partner, and that Muhammad ﷺ is His servant and Messenger.'),
    _TextItem('تیسرا کلمہ تمجید', 'Third Kalima — Tamjeed',
      'سُبْحَانَ اللّٰهِ وَالْحَمْدُ لِلّٰهِ وَلَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ الْعَلِيِّ الْعَظِيمِ',
      'اللہ پاک ہے، تمام تعریف اللہ کے لیے ہے، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے؛ نیکی کی طاقت اور گناہ سے بچنے کی قوت اللہ بلند و عظمت والے ہی کی طرف سے ہے۔',
      'Glory be to Allah; praise belongs to Allah; there is no deity except Allah; Allah is the Greatest. There is no power nor strength except through Allah, the Most High, the Magnificent.'),
    _TextItem('چوتھا کلمہ توحید', 'Fourth Kalima — Tawheed',
      'لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ أَبَدًا أَبَدًا ذُو الْجَلَالِ وَالْإِكْرَامِ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
      'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں؛ بادشاہی اسی کی ہے اور تعریف اسی کے لیے ہے؛ وہ زندہ کرتا اور موت دیتا ہے، وہ ہمیشہ زندہ ہے، کبھی نہیں مرے گا؛ عظمت اور بزرگی والا ہے، بھلائی اسی کے ہاتھ میں ہے اور وہ ہر چیز پر قادر ہے۔',
      'There is no deity except Allah alone, without partner. His is the dominion and praise. He gives life and causes death; He is Ever-Living and never dies. He is the Lord of Majesty and Honour; all good is in His hand, and He has power over everything.'),
    _TextItem('پانچواں کلمہ استغفار', 'Fifth Kalima — Istighfar',
      'أَسْتَغْفِرُ اللّٰهَ رَبِّي مِنْ كُلِّ ذَنْبٍ أَذْنَبْتُهُ عَمَدًا أَوْ خَطَأً سِرًّا أَوْ عَلَانِيَةً وَأَتُوبُ إِلَيْهِ مِنَ الذَّنْبِ الَّذِي أَعْلَمُ وَمِنَ الذَّنْبِ الَّذِي لَا أَعْلَمُ إِنَّكَ أَنْتَ عَلَّامُ الْغُيُوبِ وَسَتَّارُ الْعُيُوبِ وَغَفَّارُ الذُّنُوبِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ الْعَلِيِّ الْعَظِيمِ',
      'میں اللہ سے، جو میرا رب ہے، اپنے ہر گناہ کی معافی مانگتا ہوں جو میں نے جان بوجھ کر یا بھول کر، چھپ کر یا ظاہر کیا؛ اور ہر اس گناہ سے توبہ کرتا ہوں جسے میں جانتا ہوں یا نہیں جانتا۔ بے شک تو غیبوں کا جاننے والا، عیبوں کو چھپانے والا اور گناہوں کو بخشنے والا ہے۔ اللہ بلند و عظمت والے کے سوا نہ طاقت ہے نہ قوت۔',
      'I seek forgiveness from Allah, my Lord, for every sin, deliberate or mistaken, hidden or open. I repent for what I know and what I do not know. You know the unseen, conceal faults and forgive sins. There is no power nor strength except through Allah, the Most High, the Magnificent.'),
    _TextItem('چھٹا کلمہ ردِّ کفر', 'Sixth Kalima — Radde Kufr',
      'اللّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْئًا وَأَنَا أَعْلَمُ بِهِ وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ بِهِ تُبْتُ عَنْهُ وَتَبَرَّأْتُ مِنَ الْكُفْرِ وَالشِّرْكِ وَالْكِذْبِ وَالْغِيبَةِ وَالْبِدْعَةِ وَالنَّمِيمَةِ وَالْفَوَاحِشِ وَالْبُهْتَانِ وَالْمَعَاصِي كُلِّهَا وَأَسْلَمْتُ وَأَقُولُ لَا إِلٰهَ إِلَّا اللّٰهُ مُحَمَّدٌ رَسُولُ اللّٰهِ',
      'اے اللہ! میں تیری پناہ مانگتا ہوں اس بات سے کہ جانتے ہوئے کسی کو تیرا شریک بناؤں، اور ان باتوں کی معافی مانگتا ہوں جنہیں میں نہیں جانتا۔ میں ان سے توبہ کرتا ہوں اور کفر، شرک، جھوٹ، غیبت، بدعت، چغلی، بے حیائی، بہتان اور تمام گناہوں سے بیزاری اختیار کرتا ہوں؛ اسلام قبول کرتا ہوں اور کہتا ہوں: اللہ کے سوا کوئی معبود نہیں، محمد ﷺ اللہ کے رسول ہیں۔',
      'O Allah, I seek Your protection from knowingly associating anything with You, and seek Your forgiveness for what I do not know. I repent and disavow disbelief, associating partners, lies, backbiting, innovation, tale-bearing, indecency, slander and all sins. I submit and declare: none is worthy of worship except Allah; Muhammad ﷺ is the Messenger of Allah.'),
  ];

  static const _ayat = 'اللّٰهُ لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ';
  static const _darood = 'اللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ. اللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ.';
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _deep,
    appBar: AppBar(title: const Text('Kalimas, Ayatul Kursi & Darood'), backgroundColor: _deep, foregroundColor: _cream),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const _SectionCard(title: 'آیت الکرسی', subtitle: 'Ayatul Kursi • Surah Al-Baqarah 2:255',
        arabic: _ayat,
        urdu: 'اللہ کے سوا کوئی معبود نہیں، وہ زندہ اور سب کو قائم رکھنے والا ہے۔ اسے نہ اونگھ آتی ہے نہ نیند۔ آسمانوں اور زمین میں جو کچھ ہے اسی کا ہے۔ اس کی اجازت کے بغیر کون اس کے حضور سفارش کر سکتا ہے؟ وہ جانتا ہے جو ان کے آگے اور پیچھے ہے، اور وہ اس کے علم میں سے اتنا ہی جان سکتے ہیں جتنا وہ چاہے۔ اس کی کرسی آسمانوں اور زمین کو گھیرے ہوئے ہے، اور ان کی حفاظت اسے نہیں تھکاتی۔ وہ بلند اور عظمت والا ہے۔',
        english: 'Allah—there is no deity except Him, the Ever-Living, the Sustainer of all. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation does not tire Him. He is the Most High, the Most Great.'),
      const SizedBox(height: 12),
      const _SectionCard(title: 'درودِ ابراہیمی', subtitle: 'Durood-e-Ibrahimi • Salah',
        arabic: _darood,
        urdu: 'اے اللہ! محمد ﷺ اور آلِ محمد پر رحمت نازل فرما، جیسے تو نے ابراہیم اور آلِ ابراہیم پر رحمت نازل فرمائی۔ بے شک تو تعریف کے لائق، بزرگی والا ہے۔ اے اللہ! محمد ﷺ اور آلِ محمد پر برکت نازل فرما، جیسے تو نے ابراہیم اور آلِ ابراہیم پر برکت نازل فرمائی۔ بے شک تو تعریف کے لائق، بزرگی والا ہے۔',
        english: 'O Allah, send blessings upon Muhammad and the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim. You are Praiseworthy, Glorious. O Allah, bless Muhammad and the family of Muhammad, as You blessed Ibrahim and the family of Ibrahim. You are Praiseworthy, Glorious.'),
      const SizedBox(height: 18),
      const Text('چھ کلمے • Six Kalimas', style: TextStyle(color: _gold, fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      for (final item in _items) ...[
        _SectionCard(title: item.urduTitle, subtitle: item.englishTitle, arabic: item.arabic, urdu: item.urdu, english: item.english),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 8),
      const Text('Quran reference: Al-Baqarah 2:255. English meaning of Ayatul Kursi: Sahih International (complete verse meaning). Durood-e-Ibrahimi is taught in the hadith of Ka‘b ibn ‘Ujrah (Sahih al-Bukhari and Sahih Muslim; wording should be checked against the selected edition). The six Kalimas are a traditional South Asian teaching collection, not six Quranic verses. Please learn pronunciation from a qualified teacher.',
        style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5)),
    ]),
  );
}

class _TextItem {
  final String urduTitle, englishTitle, arabic, urdu, english;
  const _TextItem(this.urduTitle, this.englishTitle, this.arabic, this.urdu, this.english);
}

class _SectionCard extends StatelessWidget {
  final String title, subtitle, arabic, urdu, english;
  const _SectionCard({required this.title, required this.subtitle, required this.arabic, required this.urdu, required this.english});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: _deep2, borderRadius: BorderRadius.circular(20), border: Border.all(color: _gold.withOpacity(.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: _gold, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      const SizedBox(height: 14),
      Directionality(textDirection: TextDirection.rtl, child: Text(arabic, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream, fontSize: 25, height: 2.0))),
      const SizedBox(height: 14),
      const Text('اردو ترجمہ', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Text(urdu, textDirection: TextDirection.rtl, style: const TextStyle(color: _cream, height: 1.7)),
      const SizedBox(height: 12),
      const Text('English meaning', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Text(english, style: const TextStyle(color: _cream, height: 1.6)),
    ]),
  );
}
