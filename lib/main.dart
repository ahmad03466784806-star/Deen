import 'package:flutter/material.dart';
import 'janaza_page.dart';

void main() => runApp(const DeenApp());

const Color deep = Color(0xFF062F2D);
const Color deep2 = Color(0xFF0A403B);
const Color emerald = Color(0xFF146B5D);
const Color gold = Color(0xFFD9B66F);
const Color cream = Color(0xFFF4F0E6);

class DeenApp extends StatelessWidget {
  const DeenApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEEN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: deep,
        colorScheme: ColorScheme.fromSeed(seedColor: emerald, brightness: Brightness.dark,
          primary: gold, secondary: emerald, surface: deep2),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: deep, foregroundColor: cream, elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white.withOpacity(.06),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          hintStyle: TextStyle(color: cream.withOpacity(.5)),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int index = 0;
  final pages = const [HomePage(), FilesPage(), CommunityPage(), MorePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF041F20),
        indicatorColor: gold.withOpacity(.18),
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Files'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), selectedIcon: Icon(Icons.grid_view), label: 'More'),
        ],
      ),
    );
  }
}

class DeenBackground extends StatelessWidget {
  final Widget child;
  const DeenBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [deep2, deep, Color(0xFF031E20)]),
    ),
    child: Stack(children: [
      Positioned(top: -65, right: -55, child: Icon(Icons.auto_awesome, size: 230, color: gold.withOpacity(.035))),
      Positioned(bottom: 90, left: -80, child: Icon(Icons.mosque_outlined, size: 220, color: gold.withOpacity(.035))),
      child,
    ]),
  );
}

class PageHeader extends StatelessWidget {
  final String title, subtitle;
  final Widget? trailing;
  const PageHeader(this.title, {super.key, this.subtitle = 'Your Islamic Digital World', this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: cream)),
        const SizedBox(height: 3), Text(subtitle, style: TextStyle(color: cream.withOpacity(.62), fontSize: 12)),
      ])),
      if (trailing != null) trailing!,
    ]),
  );
}

class DeenCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const DeenCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.065),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: gold.withOpacity(.18)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 16, offset: const Offset(0, 7))],
    ),
    child: Material(color: Colors.transparent, child: InkWell(
      borderRadius: BorderRadius.circular(22), onTap: onTap,
      child: Padding(padding: padding, child: child),
    )),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => DeenBackground(child: ListView(
    padding: const EdgeInsets.only(bottom: 24),
    children: [
      PageHeader('Assalamu Alaikum', subtitle: 'Welcome to DEEN', trailing: CircleAvatar(
        backgroundColor: gold.withOpacity(.16), child: const Icon(Icons.notifications_none, color: gold))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: DeenCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, color: gold, height: 1.8)),
          const SizedBox(height: 8),
          const Text('Your day, guided by prayer', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: cream)),
          const SizedBox(height: 5),
          Text('Prayer schedule and Islamic date can be configured in Settings.',
            style: TextStyle(color: cream.withOpacity(.65), fontSize: 12)),
          const SizedBox(height: 14),
          Row(children: const [
            Icon(Icons.calendar_month, color: gold, size: 18),
            SizedBox(width: 7), Text('Hijri date: configure location & calendar', style: TextStyle(color: cream, fontSize: 12)),
          ]),
        ]),
      )),
      const SectionTitle('Prayer times'),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: DeenCard(child: Column(children: const [
        PrayerRow('Fajr', '—:—', Icons.nights_stay_outlined),
        PrayerRow('Dhuhr', '—:—', Icons.wb_sunny_outlined),
        PrayerRow('Asr', '—:—', Icons.sunny),
        PrayerRow('Maghrib', '—:—', Icons.wb_twilight),
        PrayerRow('Isha', '—:—', Icons.dark_mode_outlined),
      ]))),
      const SectionTitle('Quick access'),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Wrap(spacing: 10, runSpacing: 10, children: [
        QuickTile('Tasbih', Icons.touch_app, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbihPage()))),
        QuickTile('Qibla', Icons.explore_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaPage()))),
        QuickTile('Quran', Icons.menu_book, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleInfoPage(title: 'Quran', icon: Icons.menu_book, detail: 'Quran reading module will be connected here.')))),
        QuickTile('Duas', Icons.volunteer_activism, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleInfoPage(title: 'Duas & Azkar', icon: Icons.volunteer_activism, detail: 'Daily duas and azkar collection.')))),
        QuickTile('Calendar', Icons.calendar_month, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleInfoPage(title: 'Islamic Calendar', icon: Icons.calendar_month, detail: 'Hijri calendar setup will be added.')))),
        QuickTile('Zakat', Icons.account_balance_wallet_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakatPage()))),
        QuickTile('Janaza', Icons.mosque_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JanazaPage()))),
      ])),
    ],
  ));
}

class PrayerRow extends StatelessWidget {
  final String name, time; final IconData icon;
  const PrayerRow(this.name, this.time, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [
    Icon(icon, color: gold, size: 20), const SizedBox(width: 12),
    Expanded(child: Text(name, style: const TextStyle(color: cream, fontWeight: FontWeight.w600))),
    Text(time, style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
  ]));
}
class SectionTitle extends StatelessWidget {
  final String title; const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 23, 20, 10),
    child: Text(title, style: const TextStyle(color: gold, fontSize: 17, fontWeight: FontWeight.bold)));
}
class QuickTile extends StatelessWidget {
  final String title; final IconData icon; final VoidCallback onTap;
  const QuickTile(this.title, this.icon, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(width: 104, height: 92, child: DeenCard(
    padding: const EdgeInsets.all(10), onTap: onTap,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: gold, size: 27), const SizedBox(height: 8),
      Text(title, style: const TextStyle(color: cream, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  ));
}

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});
  @override
  State<TasbihPage> createState() => _TasbihPageState();
}
class _TasbihPageState extends State<TasbihPage> {
  int count = 0; int target = 33; String zikr = 'SubhanAllah';
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(title: const Text('Digital Tasbih'), backgroundColor: Colors.transparent),
    body: Center(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownButtonFormField<String>(value: zikr, dropdownColor: deep2, decoration: const InputDecoration(labelText: 'Select Zikr'),
        items: const ['SubhanAllah', 'Alhamdulillah', 'Allahu Akbar', 'Astaghfirullah', 'La ilaha illallah'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => zikr = v ?? zikr)),
      const SizedBox(height: 34),
      Text(zikr, style: const TextStyle(fontSize: 22, color: gold, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      Text('$count', style: const TextStyle(fontSize: 76, color: cream, fontWeight: FontWeight.w300)),
      Text('Target: $target', style: TextStyle(color: cream.withOpacity(.65))),
      const SizedBox(height: 28),
      GestureDetector(onTap: () => setState(() => count++), child: Container(
        width: 190, height: 190, decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [emerald, deep2]), border: Border.all(color: gold, width: 3),
          boxShadow: [BoxShadow(color: gold.withOpacity(.13), blurRadius: 25)]),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.touch_app, color: gold, size: 45), SizedBox(height: 8),
          Text('TAP', style: TextStyle(color: cream, fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      )),
      const SizedBox(height: 24),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton.icon(onPressed: () => setState(() => count = 0), icon: const Icon(Icons.refresh), label: const Text('Reset')),
        const SizedBox(width: 12),
        OutlinedButton.icon(onPressed: () => setState(() => count = 0), icon: const Icon(Icons.restart_alt), label: const Text('New round')),
      ]),
    ]))),
  ));
}

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(
    backgroundColor: Colors.transparent, appBar: AppBar(title: const Text('Qibla Direction'), backgroundColor: Colors.transparent),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.explore, color: gold, size: 170),
      const SizedBox(height: 18), const Text('Qibla Compass', style: TextStyle(color: cream, fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text('Compass and location permissions are required for a live direction.', textAlign: TextAlign.center, style: TextStyle(color: cream.withOpacity(.65))),
      const SizedBox(height: 20), const Text('Live direction not connected yet', style: TextStyle(color: gold)),
    ]))),
  ));
}

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});
  @override
  State<FilesPage> createState() => _FilesPageState();
}
class _FilesPageState extends State<FilesPage> {
  final List<String> files = ['My Quran Notes.pdf', 'Dua Collection.docx', 'Ramadan Plan.pdf'];
  void addFile() => showDialog(context: context, builder: (ctx) {
    final c = TextEditingController();
    return AlertDialog(backgroundColor: deep2, title: const Text('Add file entry'),
      content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Enter file name')),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () { if (c.text.trim().isNotEmpty) setState(() => files.add(c.text.trim())); Navigator.pop(ctx); }, child: const Text('Add'))]);
  });
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(backgroundColor: Colors.transparent,
    floatingActionButton: FloatingActionButton(backgroundColor: gold, foregroundColor: deep, onPressed: addFile, child: const Icon(Icons.add)),
    body: Column(children: [
      const PageHeader('Personal Files', subtitle: 'Your private Islamic library'),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search files'))),
      const SizedBox(height: 12),
      Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(18, 4, 18, 80), itemCount: files.length, itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10), child: DeenCard(child: Row(children: [
          const Icon(Icons.insert_drive_file_outlined, color: gold, size: 30), const SizedBox(width: 12),
          Expanded(child: Text(files[i], style: const TextStyle(color: cream, fontWeight: FontWeight.w600))),
          PopupMenuButton<String>(onSelected: (v) {
            if (v == 'Delete') setState(() => files.removeAt(i));
            if (v == 'Rename') {
              final c = TextEditingController(text: files[i]);
              showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: deep2, title: const Text('Rename file'),
                content: TextField(controller: c), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  FilledButton(onPressed: () { setState(() => files[i] = c.text); Navigator.pop(ctx); }, child: const Text('Save'))]));
            }
          }, itemBuilder: (_) => const [PopupMenuItem(value: 'Rename', child: Text('Rename')), PopupMenuItem(value: 'Share', child: Text('Share')), PopupMenuItem(value: 'Delete', child: Text('Delete'))]),
        ])),
      ))),
    ]),
  ));
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}
class _CommunityPageState extends State<CommunityPage> {
  final controller = TextEditingController();
  final List<String> posts = ['Assalamu Alaikum! May Allah bless your day.', 'Reminder: Make time for Quran recitation today.'];
  final Set<int> liked = {};
  void compose() => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: deep2, builder: (ctx) => Padding(
    padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Create a post', style: TextStyle(color: cream, fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12), TextField(controller: controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Share a beneficial reminder...')),
      const SizedBox(height: 12), SizedBox(width: double.infinity, child: FilledButton(onPressed: () {
        if (controller.text.trim().isNotEmpty) setState(() => posts.insert(0, controller.text.trim()));
        controller.clear(); Navigator.pop(ctx);
      }, child: const Text('Publish'))),
    ]),
  ));
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(backgroundColor: Colors.transparent,
    floatingActionButton: FloatingActionButton(backgroundColor: gold, foregroundColor: deep, onPressed: compose, child: const Icon(Icons.edit)),
    body: Column(children: [
      const PageHeader('Islamic Community', subtitle: 'Connect through beneficial content'),
      Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(18, 0, 18, 80), itemCount: posts.length, itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12), child: DeenCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [CircleAvatar(backgroundColor: emerald, child: Icon(Icons.person, color: cream)), SizedBox(width: 10),
            Text('DEEN Member', style: TextStyle(color: cream, fontWeight: FontWeight.bold)), Spacer(), Icon(Icons.more_horiz, color: cream)]),
          const SizedBox(height: 14), Text(posts[i], style: const TextStyle(color: cream, fontSize: 15)),
          const Divider(height: 24, color: Colors.white24),
          Row(children: [
            TextButton.icon(onPressed: () => setState(() { if (liked.contains(i)) { liked.remove(i); } else { liked.add(i); } }),
              icon: Icon(liked.contains(i) ? Icons.favorite : Icons.favorite_border, color: liked.contains(i) ? Colors.pinkAccent : gold),
              label: Text(liked.contains(i) ? 'Liked' : 'Like')),
            TextButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comments module will be connected.'))),
              icon: const Icon(Icons.comment_outlined, color: gold), label: const Text('Comment')),
            TextButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share module will be connected.'))),
              icon: const Icon(Icons.share_outlined, color: gold), label: const Text('Share')),
          ]),
        ])),
      ))),
    ]),
  ));
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) => DeenBackground(child: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
    const PageHeader('More', subtitle: 'DEEN tools and settings'),
    ...[
      ('Qibla Direction', Icons.explore, const QiblaPage()),
      ('Digital Tasbih', Icons.touch_app, const TasbihPage()),
      ('Quran', Icons.menu_book, const SimpleInfoPage(title: 'Quran', icon: Icons.menu_book, detail: 'Quran reading and audio module.')),
      ('Duas & Azkar', Icons.volunteer_activism, const SimpleInfoPage(title: 'Duas & Azkar', icon: Icons.volunteer_activism, detail: 'Daily duas and azkar collection.')),
      ('Islamic Calendar', Icons.calendar_month, const SimpleInfoPage(title: 'Islamic Calendar', icon: Icons.calendar_month, detail: 'Hijri calendar and events.')),
      ('Zakat Calculator', Icons.account_balance_wallet, const ZakatPage()),
      ('Janaza ka tariqa', Icons.mosque_outlined, const JanazaPage()),
      ('Settings', Icons.settings, const SimpleInfoPage(title: 'Settings', icon: Icons.settings, detail: 'App preferences, language, privacy and notifications.')),
      ('About DEEN', Icons.info_outline, const SimpleInfoPage(title: 'About DEEN', icon: Icons.info_outline, detail: 'Your Islamic Digital World.')),
    ].map((item) => Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5), child: DeenCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.$3)),
      child: Row(children: [Icon(item.$2, color: gold), const SizedBox(width: 14), Expanded(child: Text(item.$1, style: const TextStyle(color: cream, fontWeight: FontWeight.w600))), const Icon(Icons.chevron_right, color: cream)]),
    ))),
  ]));
}

class SimpleInfoPage extends StatelessWidget {
  final String title, detail; final IconData icon;
  const SimpleInfoPage({super.key, required this.title, required this.icon, required this.detail});
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(backgroundColor: Colors.transparent,
    appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
    body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: gold, size: 85), const SizedBox(height: 20),
      Text(title, style: const TextStyle(color: cream, fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10), Text(detail, textAlign: TextAlign.center, style: TextStyle(color: cream.withOpacity(.7))),
      const SizedBox(height: 22), const Text('Coming in the next development phase', style: TextStyle(color: gold)),
    ]))),
  ));
}

class ZakatPage extends StatefulWidget {
  const ZakatPage({super.key});
  @override
  State<ZakatPage> createState() => _ZakatPageState();
}
class _ZakatPageState extends State<ZakatPage> {
  final cash = TextEditingController(), goldValue = TextEditingController(), silverValue = TextEditingController(), investments = TextEditingController(), debts = TextEditingController();
  double get total {
    double v(String s) => double.tryParse(s) ?? 0;
    return (v(cash.text) + v(goldValue.text) + v(silverValue.text) + v(investments.text) - v(debts.text)).clamp(0, double.infinity);
  }
  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(backgroundColor: Colors.transparent,
    appBar: AppBar(title: const Text('Zakat Calculator'), backgroundColor: Colors.transparent),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Enter your assets (PKR)', style: TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      for (final item in [('Cash & bank', cash), ('Gold value', goldValue), ('Silver value', silverValue), ('Investments / business', investments), ('Due debts', debts)])
        Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: item.$2, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: item.$1, prefixText: 'Rs. '))),
      DeenCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Estimated zakatable amount', style: TextStyle(color: cream)),
        const SizedBox(height: 6), Text('Rs. ${total.toStringAsFixed(2)}', style: const TextStyle(color: gold, fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), Text('Illustrative 2.5% estimate: Rs. ${(total * .025).toStringAsFixed(2)}', style: const TextStyle(color: cream)),
        const SizedBox(height: 8), Text('Please verify nisab, lunar-year conditions and applicable rulings with a qualified scholar.', style: TextStyle(color: cream.withOpacity(.65), fontSize: 11)),
      ])),
    ]),
  ));
}
