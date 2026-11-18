import 'package:material_ui/material_ui.dart';

import 'fire_escape_demo.dart';
import 'runner_demo.dart';

void main() {
  runApp(const EscapeApp());
}

class EscapeApp extends StatelessWidget {
  const EscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7 Day Escape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315B43),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F1),
        fontFamily: 'Roboto',
      ),
      home: const EscapeHomePage(),
    );
  }
}

class EscapeHomePage extends StatelessWidget {
  const EscapeHomePage({super.key});

  void _openDemo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;
            final pageWidth = constraints.maxWidth > 1180
                ? 1180.0
                : constraints.maxWidth;
            final horizontalPadding = isWide ? 38.0 : 20.0;

            return Center(
              child: SizedBox(
                width: pageWidth,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    22,
                    horizontalPadding,
                    36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 28),
                      _buildHero(context, isWide),
                      const SizedBox(height: 26),
                      _buildQuickFacts(context, isWide),
                      const SizedBox(height: 36),
                      _buildSectionHeading(context),
                      const SizedBox(height: 16),
                      _buildDemoCards(
                        context,
                        pageWidth - horizontalPadding * 2,
                      ),
                      const SizedBox(height: 24),
                      _buildSafetyNote(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF315B43),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: const Text(
            '7',
            style: TextStyle(
              color: Color(0xFFF0F4C3),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DAY ESCAPE',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: const Color(0xFF20352A),
                  ),
            ),
            Text(
              'DISASTER TRAINING',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.25,
                    color: const Color(0xFF718078),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFE7EEE7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 8, color: Color(0xFF4F8B5C)),
              SizedBox(width: 7),
              Text(
                'DEMO MODE',
                style: TextStyle(
                  color: Color(0xFF315B43),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF203D31), Color(0xFF315B43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: isWide ? 182 : -42,
            top: -110,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 34,
                ),
              ),
            ),
          ),
          Positioned(
            right: isWide ? 40 : -86,
            bottom: -156,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFDDEB8B).withValues(alpha: 0.11),
                  width: 46,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isWide ? 34 : 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: const Text(
                          'SURVIVAL SIMULATION  /  DAY 01',
                          style: TextStyle(
                            color: Color(0xFFE6EECE),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'หนึ่งภารกิจ\nเพื่อไปให้ถึง Safe Zone',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isWide ? 34 : 27,
                          height: 1.18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'ฝึกสังเกต ตัดสินใจ และเอาตัวรอด\nในสถานการณ์จำลองจาก 7 Day Escape',
                        style: TextStyle(
                          color: Color(0xFFD4DED5),
                          height: 1.55,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        key: const Key('start-runner-button'),
                        onPressed: () => _openDemo(
                          context,
                          const RunnerDemoPage(),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 21),
                        label: const Text('เริ่มภารกิจแรก'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDDEB8B),
                          foregroundColor: const Color(0xFF203D31),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: 30),
                  Expanded(child: _buildHeroArtwork()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroArtwork() {
    return Container(
      height: 218,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.radar_rounded,
                color: Color(0xFFDDEB8B),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'TRAINING STATUS',
                style: TextStyle(
                  color: Color(0xFFD8E1D8),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '01',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 66,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 9),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '/ 07 DAYS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 1 / 7,
              minHeight: 7,
              backgroundColor: Color(0xFF486556),
              valueColor: AlwaysStoppedAnimation(Color(0xFFDDEB8B)),
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'จุดหมาย: Safe Zone',
            style: TextStyle(
              color: Color(0xFFE2E9DF),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFacts(BuildContext context, bool isWide) {
    final facts = [
      _QuickFact(
        icon: Icons.flag_rounded,
        value: '01 / 07',
        label: 'วันฝึกจำลอง',
        color: const Color(0xFF315B43),
      ),
      _QuickFact(
        icon: Icons.sports_esports_rounded,
        value: '02',
        label: 'เดโมที่เล่นได้',
        color: const Color(0xFFBE6A37),
      ),
      _QuickFact(
        icon: Icons.shield_outlined,
        value: 'SAFE',
        label: 'ฝึกก่อนลงสนาม',
        color: const Color(0xFF617D99),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = isWide
            ? (constraints.maxWidth - 24) / 3
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final fact in facts)
              SizedBox(
                width: itemWidth,
                child: _QuickFactCard(fact: fact),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeading(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เลือกช่องฝึก',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF20352A),
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 5),
              const Text(
                'ช่องแรกเล่นมินิเกม ช่องถัดไปตอบพัซเซิล',
                style: TextStyle(
                  color: Color(0xFF748078),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE7EEE7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '2 CHANNELS',
            style: TextStyle(
              color: Color(0xFF315B43),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCards(BuildContext context, double availableWidth) {
    final cards = [
      _DemoCardData(
        key: const Key('runner-demo-card'),
        number: '01',
        label: 'CHANNEL 01 · MINI GAME',
        title: 'มินิเกมหนีออกจากอาคาร',
        description:
            'เดินตามลูกศรไปยังประตู แล้วเข้าสู่ช่วงวิ่งกระโดดหลบซากให้ครบ 6 ชิ้น',
        icon: Icons.directions_run_rounded,
        accent: const Color(0xFFD57D46),
        surface: const Color(0xFFFFF1E7),
        tags: const ['มุมมองด้านบน', 'กระโดดหลบ 6 อุปสรรค'],
        buttonKey: const Key('runner-card-button'),
        onPressed: () => _openDemo(context, const RunnerDemoPage()),
      ),
      _DemoCardData(
        key: const Key('fire-demo-card'),
        number: '02',
        label: 'CHANNEL 02 · PUZZLE',
        title: 'พัซเซิลตอบคำถาม',
        description:
            'ตอบคำถามจากสถานการณ์ไฟไหม้ น้ำท่วม และแผ่นดินไหว พร้อมดูคะแนนและคำอธิบาย',
        icon: Icons.local_fire_department_rounded,
        accent: const Color(0xFFB9503A),
        surface: const Color(0xFFFFE9E4),
        tags: const ['3 คำถาม', 'คะแนนและเฉลย'],
        buttonKey: const Key('fire-demo-button'),
        onPressed: () => _openDemo(context, const FireEscapeDemoPage()),
      ),
    ];

    return SizedBox(
      width: availableWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < cards.length; index++) ...[
            _MissionCard(data: cards[index]),
            if (index < cards.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSafetyNote(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDE7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF5C7162),
            size: 20,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'เดโมนี้เป็นเกมจำลองเพื่อการเรียนรู้ ไม่แทนคำแนะนำจากหน่วยงานฉุกเฉิน '
              'เมื่อเกิดเหตุจริงให้ทำตามคำแนะนำของเจ้าหน้าที่',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.55,
                    color: const Color(0xFF5E6B62),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickFact {
  const _QuickFact({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _QuickFactCard extends StatelessWidget {
  const _QuickFactCard({required this.fact});

  final _QuickFact fact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAE3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: fact.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(fact.icon, color: fact.color, size: 21),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fact.value,
                style: const TextStyle(
                  color: Color(0xFF27382E),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                fact.label,
                style: const TextStyle(
                  color: Color(0xFF7A857D),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemoCardData {
  const _DemoCardData({
    required this.key,
    required this.number,
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.surface,
    required this.tags,
    required this.buttonKey,
    required this.onPressed,
  });

  final Key key;
  final String number;
  final String label;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final Color surface;
  final List<String> tags;
  final Key buttonKey;
  final VoidCallback onPressed;
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.data});

  final _DemoCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: data.key,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFE4E9E2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B21372A),
            blurRadius: 22,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: data.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(data.icon, color: data.accent, size: 25),
              ),
              const Spacer(),
              Text(
                data.number,
                style: TextStyle(
                  color: data.accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            data.label,
            style: TextStyle(
              color: data.accent,
              fontSize: 10,
              letterSpacing: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF26392E),
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF718078),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tag in data.tags)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Color(0xFF647167),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: data.buttonKey,
              onPressed: data.onPressed,
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: const Text('เปิดเดโม'),
              style: OutlinedButton.styleFrom(
                foregroundColor: data.accent,
                side: BorderSide(color: data.accent.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
