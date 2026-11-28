import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'prayer_times_service.dart';
import 'kalimaat_page.dart';
import 'quran_page.dart';
import 'prayer_times_page.dart';
import 'islamic_calendar_page.dart';
import 'janaza_page.dart';
import 'duas_page.dart';
import 'deen_khazana_page.dart';

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
  final AudioPlayer _openingDaroodPlayer = AudioPlayer();
  static const String _openingDaroodUrl = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Muhammad_Peace_be_Upon_Him-ar.wav';
  bool _daroodAutoplayEnabled = true;
  bool _daroodPlaying = false;
  String? _daroodAudioMessage;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PrayerTimesService.instance.initialize();
      await _openingDaroodPlayer.setReleaseMode(ReleaseMode.stop);
      _openingDaroodPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) setState(() => _daroodPlaying = state == PlayerState.playing);
      });
      if (_daroodAutoplayEnabled) await _playOpeningDarood();
    });
  }
  Future<void> _playOpeningDarood() async {
    try {
      await _openingDaroodPlayer.play(UrlSource(_openingDaroodUrl));
      if (mounted) setState(() => _daroodAudioMessage = null);
    } catch (_) {
      if (mounted) setState(() => _daroodAudioMessage = 'Audio needs an internet connection. You can read the complete Darood below.');
    }
  }

  Future<void> _setDaroodAutoplay(bool enabled) async {
    setState(() { _daroodAutoplayEnabled = enabled; _daroodAudioMessage = null; });
    if (enabled) {
      await _playOpeningDarood();
    } else {
      await _openingDaroodPlayer.stop();
    }
  }

  Future<void> _toggleDaroodPlayback() async {
    if (_daroodPlaying) {
      await _openingDaroodPlayer.pause();
    } else {
      await _playOpeningDarood();
    }
  }

  @override
  void dispose() {
    _openingDaroodPlayer.dispose();
    super.dispose();
  }
  int index = 0;
  List<Widget> get pages => [
    HomePage(daroodAutoplayEnabled: _daroodAutoplayEnabled, daroodPlaying: _daroodPlaying,
      daroodAudioMessage: _daroodAudioMessage, onDaroodAutoplayChanged: _setDaroodAutoplay,
      onDaroodPlaybackTap: _toggleDaroodPlayback),
    const FilesPage(), const CommunityPage(), const MorePage(),
  ];
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
  final bool daroodAutoplayEnabled;
  final bool daroodPlaying;
  final String? daroodAudioMessage;
  final ValueChanged<bool> onDaroodAutoplayChanged;
  final VoidCallback onDaroodPlaybackTap;
  const HomePage({super.key, required this.daroodAutoplayEnabled, required this.daroodPlaying,
    required this.daroodAudioMessage, required this.onDaroodAutoplayChanged, required this.onDaroodPlaybackTap});

  @override
  Widget build(BuildContext context) => DeenBackground(
    child: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: gold.withOpacity(.14),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: gold.withOpacity(.35)),
                    ),
                    child: const Icon(Icons.mosque_outlined, color: gold, size: 27),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DEEN', style: TextStyle(color: gold, fontSize: 12, letterSpacing: 2.4, fontWeight: FontWeight.w800)),
                      SizedBox(height: 2),
                      Text('Assalamu Alaikum', style: TextStyle(color: cream, fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  )),
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications will be available after setup.')),
                    ),
                    icon: const Icon(Icons.notifications_none_rounded, color: cream),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF176B5B), Color(0xFF083A36), Color(0xFF062B2B)],
                  ),
                  border: Border.all(color: gold.withOpacity(.42)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.22), blurRadius: 22, offset: const Offset(0, 10))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Center(child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: gold, fontSize: 23, height: 1.9),
                  )),
                  const SizedBox(height: 12),
                  const Text('Your day, guided by prayer', style: TextStyle(color: cream, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('A peaceful space for worship, learning and daily reminders.',
                    style: TextStyle(color: cream.withOpacity(.78), height: 1.45)),
                  const SizedBox(height: 17),
                  Row(children: [
                    const Icon(Icons.calendar_month_outlined, color: gold, size: 19),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Hijri date', style: TextStyle(color: cream, fontWeight: FontWeight.w600))),
                    AnimatedBuilder(
                      animation: PrayerTimesService.instance,
                      builder: (context, _) => Text(
                        PrayerTimesService.instance.hijriDate ?? PrayerTimesService.instance.locationLabel,
                        style: TextStyle(color: cream.withOpacity(.7), fontSize: 11),
                      ),
                    ),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),
              DeenCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.volume_up_rounded, color: gold, size: 23),
                  const SizedBox(width: 9),
                  const Expanded(child: Text('Opening Darood audio', style: TextStyle(color: cream, fontWeight: FontWeight.bold))),
                  IconButton(onPressed: onDaroodPlaybackTap,
                    icon: Icon(daroodPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: gold, size: 30), tooltip: daroodPlaying ? 'Pause Darood' : 'Play Darood'),
                ]),
                Row(children: [
                  const Expanded(child: Text('Play automatically when DEEN opens', style: TextStyle(color: cream, fontSize: 12))),
                  Switch(value: daroodAutoplayEnabled, onChanged: onDaroodAutoplayChanged, activeColor: gold),
                ]),
                if (daroodAudioMessage != null)
                  Text(daroodAudioMessage!, style: const TextStyle(color: gold, fontSize: 11)),
                const Text('Audio streams online. The written Darood remains available without internet. Audio: باسم, Wikimedia Commons (CC BY 4.0).',
                  style: TextStyle(color: Colors.white54, fontSize: 10)),
              ])),
              const SizedBox(height: 14),
              Row(children: [
                const Expanded(child: SectionTitle('Prayer times')),
                TextButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const PrayerTimesPage(),
                  )),
                  icon: const Icon(Icons.tune, size: 16, color: gold),
                  label: const Text('Setup', style: TextStyle(color: gold)),
                ),
              ]),
              AnimatedBuilder(
                animation: PrayerTimesService.instance,
                builder: (context, _) {
                  final prayerService = PrayerTimesService.instance;
                  final times = prayerService.timings;
                  return Column(children: [
                    DeenCard(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Column(children: [
                        PrayerRow('Fajr', times?['Fajr']?.toString() ?? '—:—', Icons.nights_stay_outlined),
                        const Divider(color: Colors.white12, height: 1),
                        PrayerRow('Dhuhr', times?['Dhuhr']?.toString() ?? '—:—', Icons.wb_sunny_outlined),
                        const Divider(color: Colors.white12, height: 1),
                        PrayerRow('Asr', times?['Asr']?.toString() ?? '—:—', Icons.sunny),
                        const Divider(color: Colors.white12, height: 1),
                        PrayerRow('Maghrib', times?['Maghrib']?.toString() ?? '—:—', Icons.wb_twilight),
                        const Divider(color: Colors.white12, height: 1),
                        PrayerRow('Isha', times?['Isha']?.toString() ?? '—:—', Icons.dark_mode_outlined),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    if (prayerService.loading)
                      const LinearProgressIndicator(minHeight: 2, color: gold, backgroundColor: Colors.white12),
                    if (prayerService.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(prayerService.errorMessage!, style: TextStyle(color: cream.withOpacity(.65), fontSize: 11)),
                      )
                    else
                      Text(
                        prayerService.timings == null
                            ? 'Allow location access or open Setup to enter your city.'
                            : '${prayerService.locationLabel} • Hanafi Asr setting',
                        style: TextStyle(color: cream.withOpacity(.58), fontSize: 11, height: 1.4),
                      ),
                  ]);
                },
              ),
              const SectionTitle('Worship & learning'),
              LayoutBuilder(builder: (context, constraints) {
                final columns = constraints.maxWidth >= 560 ? 4 : 2;
                final items = <_HomeAction>[
                  _HomeAction('6 Kalimas + Ayatul Kursi + Darood', Icons.auto_stories_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KalimaatPage()))),
                  _HomeAction('Quran', Icons.menu_book_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranPage()))),
                  _HomeAction('Duas', Icons.volunteer_activism_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DuasPage()))),
                  _HomeAction('Janaza', Icons.mosque_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JanazaPage()))),
                  _HomeAction('Hadith Library', Icons.auto_stories_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeenKhazanaPage()))),
                  _HomeAction('Tasbih', Icons.touch_app_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbihPage()))),
                  _HomeAction('Qibla', Icons.explore_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaPage()))),
                  _HomeAction('Zakat', Icons.account_balance_wallet_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakatPage()))),
                  _HomeAction('Calendar', Icons.calendar_month_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCalendarPage()))),
                ];
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns, crossAxisSpacing: 11, mainAxisSpacing: 11,
                    mainAxisExtent: 104,
                  ),
                  itemBuilder: (context, index) => _HomeActionTile(action: items[index]),
                );
              }),
              const SizedBox(height: 20),
              DeenCard(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JanazaPage())),
                child: Row(children: [
                  const Icon(Icons.menu_book_outlined, color: gold, size: 30),
                  const SizedBox(width: 13),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Learn step by step', style: TextStyle(color: cream, fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text('Janaza guide and essential duas', style: TextStyle(color: cream, fontSize: 12)),
                  ])),
                  const Icon(Icons.arrow_forward_ios_rounded, color: gold, size: 16),
                ]),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _HomeAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _HomeAction(this.title, this.icon, this.onTap);
}

class _HomeActionTile extends StatelessWidget {
  final _HomeAction action;
  const _HomeActionTile({required this.action});
  @override
  Widget build(BuildContext context) => DeenCard(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    onTap: action.onTap,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(action.icon, color: gold, size: 27),
      const SizedBox(height: 9),
      Text(action.title, textAlign: TextAlign.center,
        maxLines: 2, overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: cream, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
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
      DropdownButtonFormField<int>(
        value: target,
        dropdownColor: deep2,
        decoration: const InputDecoration(labelText: 'Round target'),
        items: const [33, 99, 100, 500].map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
        onChanged: (v) => setState(() { target = v ?? target; count = 0; }),
      ),
      const SizedBox(height: 14),
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

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  double? _bearing;
  String? _error;

  void _calculate() {
    final lat = double.tryParse(_latitude.text.trim());
    final lon = double.tryParse(_longitude.text.trim());
    if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      setState(() { _error = 'Valid latitude (-90 to 90) and longitude (-180 to 180) enter karein.'; _bearing = null; });
      return;
    }
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;
    final phi1 = lat * math.pi / 180;
    final phi2 = kaabaLat * math.pi / 180;
    final deltaLon = (kaabaLon - lon) * math.pi / 180;
    final y = math.sin(deltaLon) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLon);
    final degrees = (math.atan2(y, x) * 180 / math.pi + 360) % 360;
    setState(() { _bearing = degrees; _error = null; });
  }

  @override
  void dispose() {
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DeenBackground(child: Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(title: const Text('Qibla Direction'), backgroundColor: Colors.transparent),
    body: ListView(padding: const EdgeInsets.all(22), children: [
      const Text('Qibla bearing calculator', style: TextStyle(color: gold, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Apne current location ke latitude aur longitude enter karein. App Kaaba (21.4225° N, 39.8262° E) ki taraf true-north se bearing calculate karegi.',
        style: TextStyle(color: cream.withOpacity(.72), height: 1.5)),
      const SizedBox(height: 18),
      TextField(controller: _latitude, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: const InputDecoration(labelText: 'Latitude', hintText: 'e.g. 31.5204')),
      const SizedBox(height: 10),
      TextField(controller: _longitude, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: const InputDecoration(labelText: 'Longitude', hintText: 'e.g. 74.3587')),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: _calculate, icon: const Icon(Icons.explore), label: const Text('Calculate Qibla direction'),
        style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: deep)),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.orangeAccent))),
      if (_bearing != null) ...[
        const SizedBox(height: 28),
        Center(child: SizedBox(width: 210, height: 210, child: Stack(alignment: Alignment.center, children: [
          Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: gold, width: 2), color: deep2)),
          const Positioned(top: 12, child: Text('N', style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 18))),
          Transform.rotate(angle: _bearing! * math.pi / 180, child: const Icon(Icons.navigation, color: gold, size: 112)),
          const Positioned(bottom: 12, child: Text('True North reference', style: TextStyle(color: cream, fontSize: 10))),
        ]))),
        const SizedBox(height: 18),
        Center(child: Text('${_bearing!.toStringAsFixed(1)}°', style: const TextStyle(color: gold, fontSize: 34, fontWeight: FontWeight.bold))),
        const Center(child: Text('Clockwise from true north', style: TextStyle(color: cream))),
      ],
      const SizedBox(height: 18),
      Text('Important: Yeh bearing calculation hai, live magnetic compass nahi. Phone compass ki calibration, magnetic declination aur nearby metal/electronics direction ko affect kar sakte hain. Namaz se pehle local masjid ya trusted Qibla tool se tasdeeq karein.',
        style: TextStyle(color: cream.withOpacity(.62), fontSize: 11, height: 1.5)),
    ]),
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
  final Map<int, List<String>> comments = {};

  void commentOn(int postIndex) {
    final input = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: deep2,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, refreshSheet) => Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.of(sheetContext).viewInsets.bottom + 18),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Comments', style: TextStyle(color: cream, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if ((comments[postIndex] ?? []).isEmpty)
              const Text('Abhi koi comment nahi. Pehla comment karein.', style: TextStyle(color: Colors.white70))
            else
              ...comments[postIndex]!.map((comment) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: emerald, child: Icon(Icons.person, color: cream)),
                title: Text(comment, style: const TextStyle(color: cream)),
              )),
            const SizedBox(height: 8),
            TextField(controller: input, maxLines: 2, decoration: const InputDecoration(hintText: 'Write a respectful comment…')),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                final value = input.text.trim();
                if (value.isEmpty) return;
                setState(() => comments.putIfAbsent(postIndex, () => []).add(value));
                input.clear();
                refreshSheet(() {});
              },
              child: const Text('Add comment'),
            ),
            const SizedBox(height: 4),
            const Text('Comments are currently stored in this app session only. Firebase sync is not connected yet.',
              style: TextStyle(color: Colors.white54, fontSize: 10)),
          ]),
        ),
      ),
    ).whenComplete(input.dispose);
  }
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
            TextButton.icon(onPressed: () => commentOn(i),
              icon: const Icon(Icons.comment_outlined, color: gold), label: Text('Comment ${comments[i]?.length ?? 0}')),
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
      ('6 Kalimas, Ayatul Kursi & Darood', Icons.auto_stories, const KalimaatPage()),
      ('Quran', Icons.menu_book, const QuranPage()),
      ('Duas & Azkar', Icons.volunteer_activism, const DuasPage()),
      ('Prayer Times', Icons.access_time, const PrayerTimesPage()),
      ('Islamic Calendar', Icons.calendar_month, const IslamicCalendarPage()),
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
  void dispose() {
    cash.dispose();
    goldValue.dispose();
    silverValue.dispose();
    investments.dispose();
    debts.dispose();
    super.dispose();
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
