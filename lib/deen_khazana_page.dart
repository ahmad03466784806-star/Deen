import 'package:flutter/material.dart';

const Color _khazanaDeep = Color(0xFF062F2D);
const Color _khazanaGreen = Color(0xFF0A403B);
const Color _khazanaGold = Color(0xFFD9B66F);
const Color _khazanaCream = Color(0xFFF4F0E6);

class DeenKhazanaPage extends StatefulWidget {
  const DeenKhazanaPage({super.key});

  @override
  State<DeenKhazanaPage> createState() => _DeenKhazanaPageState();
}

class _DeenKhazanaPageState extends State<DeenKhazanaPage> {
  final TextEditingController _search = TextEditingController();
  String _language = 'All';

  static const _books = <_HadithCollection>[
    _HadithCollection(
      title: 'Sahih al-Bukhari',
      arabic: 'صحيح البخاري',
      compiler: 'Imam Muhammad ibn Isma‘il al-Bukhari (رحمه الله)',
      description: 'Hadith ki mashhoor aur mu‘tabar Sahih collection.',
      count: '7,5xx (edition/numbering ke mutabiq farq ho sakta hai)',
      url: 'https://sunnah.com/bukhari',
    ),
    _HadithCollection(
      title: 'Sahih Muslim',
      arabic: 'صحيح مسلم',
      compiler: 'Imam Muslim ibn al-Hajjaj (رحمه الله)',
      description: 'Sahih ahadith ki mashhoor collection.',
      count: '7,4xx (edition/numbering ke mutabiq farq ho sakta hai)',
      url: 'https://sunnah.com/muslim',
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final filtered = _books.where((book) =>
        query.isEmpty ||
        book.title.toLowerCase().contains(query) ||
        book.arabic.contains(query) ||
        book.compiler.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: _khazanaDeep,
      appBar: AppBar(
        title: const Text('Deen ka Khazana'),
        backgroundColor: _khazanaDeep,
        foregroundColor: _khazanaCream,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _khazanaGreen,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _khazanaGold.withOpacity(.35)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('احادیثِ مبارکہ', textDirection: TextDirection.rtl,
                    style: TextStyle(color: _khazanaGold, fontSize: 25, height: 1.8)),
                SizedBox(height: 8),
                Text('Authentic Hadith Library',
                    style: TextStyle(color: _khazanaCream, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Arabic matn • Urdu tarjuma • English translation',
                    style: TextStyle(color: _khazanaCream, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: _khazanaCream),
            decoration: InputDecoration(
              hintText: 'Search collection / kitab',
              hintStyle: TextStyle(color: _khazanaCream.withOpacity(.55)),
              prefixIcon: const Icon(Icons.search, color: _khazanaGold),
              filled: true,
              fillColor: _khazanaGreen,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _language,
            dropdownColor: _khazanaGreen,
            style: const TextStyle(color: _khazanaCream),
            decoration: InputDecoration(
              labelText: 'Display languages',
              labelStyle: const TextStyle(color: _khazanaGold),
              filled: true,
              fillColor: _khazanaGreen,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
            items: const [
              DropdownMenuItem(value: 'All', child: Text('Arabic + Urdu + English')),
              DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
              DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
              DropdownMenuItem(value: 'English', child: Text('English')),
            ],
            onChanged: (value) => setState(() => _language = value ?? 'All'),
          ),
          const SizedBox(height: 18),
          const Text('Kutub-e-Sittah mein se aapki muntakhib Sahih collections',
              style: TextStyle(color: _khazanaGold, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          for (final book in filtered) ...[
            _CollectionCard(
              book: book,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => _CollectionInfoPage(book: book, language: _language),
              )),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text(
            'Zaroori wazahat: Yeh library ka navigation aur language interface hai. '
            'Mukammal hadith matn aur Urdu/English tarjume abhi app ke andar import nahi hue. '
            'Ghair-mutasaddiq matn ya tarjuma ko authentic keh kar nahi dikhaya jayega. '
            'Har riwayat ke saath collection, hadith number, edition/source aur asal reference dena zaroori hai.',
            style: TextStyle(color: _khazanaCream.withOpacity(.7), fontSize: 12, height: 1.55),
          ),
          const SizedBox(height: 10),
          const Text('Source: Sunnah.com — collection pages and references',
              style: TextStyle(color: _khazanaGold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HadithCollection {
  final String title, arabic, compiler, description, count, url;
  const _HadithCollection({
    required this.title,
    required this.arabic,
    required this.compiler,
    required this.description,
    required this.count,
    required this.url,
  });
}

class _CollectionCard extends StatelessWidget {
  final _HadithCollection book;
  final VoidCallback onTap;
  const _CollectionCard({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: _khazanaGreen,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              const CircleAvatar(
                backgroundColor: _khazanaGold,
                child: Icon(Icons.menu_book, color: _khazanaDeep),
              ),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(book.title, style: const TextStyle(color: _khazanaCream, fontSize: 17, fontWeight: FontWeight.bold)),
                Text(book.arabic, textDirection: TextDirection.rtl, style: const TextStyle(color: _khazanaGold, fontSize: 18)),
                Text(book.compiler, style: TextStyle(color: _khazanaCream.withOpacity(.7), fontSize: 11)),
              ])),
              const Icon(Icons.chevron_right, color: _khazanaGold),
            ]),
          ),
        ),
      );
}

class _CollectionInfoPage extends StatelessWidget {
  final _HadithCollection book;
  final String language;
  const _CollectionInfoPage({required this.book, required this.language});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _khazanaDeep,
        appBar: AppBar(title: Text(book.title), backgroundColor: _khazanaDeep, foregroundColor: _khazanaCream),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Text(book.arabic, textDirection: TextDirection.rtl,
              style: const TextStyle(color: _khazanaGold, fontSize: 28, height: 2)),
          Text(book.compiler, style: const TextStyle(color: _khazanaCream, fontSize: 16)),
          const SizedBox(height: 12),
          Text(book.description, style: const TextStyle(color: _khazanaCream, height: 1.5)),
          const SizedBox(height: 8),
          Text('Hadith count: ${book.count}', style: const TextStyle(color: _khazanaGold)),
          const SizedBox(height: 18),
          const Text('Language selection', style: TextStyle(color: _khazanaGold, fontWeight: FontWeight.bold)),
          Text(language == 'All' ? 'Arabic + Urdu + English' : language,
              style: const TextStyle(color: _khazanaCream)),
          const SizedBox(height: 18),
          const Text(
            'Collection ka full text is build mein abhi embedded nahi hai. '
            'Sunnah.com par asal collection aur hadith references dekhein. '
            'In-app full text ke liye verified, licensed Arabic aur translations ka data source/API configure karna baqi hai.',
            style: TextStyle(color: _khazanaCream, height: 1.6),
          ),
          const SizedBox(height: 16),
          SelectableText(book.url, style: const TextStyle(color: _khazanaGold, decoration: TextDecoration.underline)),
          const SizedBox(height: 8),
          const Text('Hadith se fiqhi hukm nikalne ke liye qualified ulama ki rehnumai zaroori hai.',
              style: TextStyle(color: _khazanaCream, fontSize: 12, height: 1.5)),
        ]),
      );
}
