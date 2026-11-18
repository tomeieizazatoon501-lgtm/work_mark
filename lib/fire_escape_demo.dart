import 'package:material_ui/material_ui.dart';

class FireEscapeDemoPage extends StatefulWidget {
  const FireEscapeDemoPage({super.key});

  @override
  State<FireEscapeDemoPage> createState() => _FireEscapeDemoPageState();
}

class _FireEscapeDemoPageState extends State<FireEscapeDemoPage> {
  int _scenarioIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;

  bool get _isComplete => _scenarioIndex >= _scenarios.length;

  void _selectAnswer(int index) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedAnswer = index;
      if (index == _scenarios[_scenarioIndex].correctAnswer) {
        _correctAnswers++;
      }
    });
  }

  void _nextScenario() {
    setState(() {
      _scenarioIndex++;
      _selectedAnswer = null;
    });
  }

  void _restart() {
    setState(() {
      _scenarioIndex = 0;
      _correctAnswers = 0;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F1),
        titleSpacing: 0,
        title: const Text(
          'ภารกิจ 02 · ตัดสินใจก่อนหนีไฟ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF20352A),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: _isComplete ? _buildResults(context) : _buildQuestion(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final scenario = _scenarios[_scenarioIndex];
    final selectedIsCorrect = _selectedAnswer == scenario.correctAnswer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DECISION TRAINING',
                    style: TextStyle(
                      color: Color(0xFFB9503A),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'สถานการณ์ ${_scenarioIndex + 1} / ${_scenarios.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF26392E),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '$_correctAnswers คะแนน',
              style: const TextStyle(
                color: Color(0xFF315B43),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: (_scenarioIndex + 1) / _scenarios.length,
            minHeight: 6,
            backgroundColor: const Color(0xFFE0E7DF),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFB9503A)),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF493A34), Color(0xFF714B3E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(scenario.icon, color: const Color(0xFFFFC28D)),
              ),
              const SizedBox(height: 17),
              Text(
                scenario.location,
                style: const TextStyle(
                  color: Color(0xFFFFC28D),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scenario.story,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  height: 1.45,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                scenario.question,
                style: const TextStyle(
                  color: Color(0xFFE6DCD6),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'คุณจะทำอย่างไร?',
          style: TextStyle(
            color: Color(0xFF26392E),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 11),
        for (var index = 0; index < scenario.answers.length; index++) ...[
          _AnswerOption(
            key: Key('answer-$index'),
            text: scenario.answers[index],
            index: index,
            selected: _selectedAnswer == index,
            enabled: _selectedAnswer == null,
            correct: index == scenario.correctAnswer,
            showResult: _selectedAnswer != null,
            onTap: () => _selectAnswer(index),
          ),
          const SizedBox(height: 9),
        ],
        if (_selectedAnswer != null) ...[
          const SizedBox(height: 6),
          Container(
            key: const Key('answer-feedback'),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: selectedIsCorrect
                  ? const Color(0xFFE7F1E8)
                  : const Color(0xFFFFEEE8),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selectedIsCorrect
                    ? const Color(0xFFC9DEC9)
                    : const Color(0xFFF3CEC1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedIsCorrect ? 'ตัดสินใจถูกต้อง' : 'ลองทบทวนอีกครั้ง',
                  style: TextStyle(
                    color: selectedIsCorrect
                        ? const Color(0xFF315B43)
                        : const Color(0xFF9A4936),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  scenario.explanation,
                  style: const TextStyle(
                    color: Color(0xFF5F6C63),
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('scenario-next-button'),
              onPressed: _nextScenario,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF315B43),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _scenarioIndex == _scenarios.length - 1
                    ? 'ดูผลการฝึก'
                    : 'สถานการณ์ถัดไป',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'สถานการณ์นี้เป็นแบบจำลอง ให้ยึดคำแนะนำจากหน่วยงานฉุกเฉินเมื่อเกิดเหตุจริง',
          style: TextStyle(
            color: Color(0xFF7A857D),
            fontSize: 11,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    final perfectScore = _correctAnswers == _scenarios.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE4E9E2)),
          ),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: perfectScore
                      ? const Color(0xFFE7F1E8)
                      : const Color(0xFFFFF1E7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  perfectScore
                      ? Icons.verified_rounded
                      : Icons.shield_outlined,
                  color: perfectScore
                      ? const Color(0xFF315B43)
                      : const Color(0xFFBE6A37),
                  size: 37,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                perfectScore ? 'พร้อมเข้าสู่ Safe Zone' : 'จบการฝึกแล้ว',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF26392E),
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'คุณตอบถูก $_correctAnswers จาก ${_scenarios.length} สถานการณ์',
                style: const TextStyle(
                  color: Color(0xFF718078),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 21),
              const Text(
                'การฝึกสังเกตความเสี่ยงและเลือกเส้นทางปลอดภัย '
                'ช่วยให้พร้อมรับมือสถานการณ์จำลองได้ดีขึ้น',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5F6C63),
                  height: 1.6,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          key: const Key('quiz-retry-button'),
          onPressed: _restart,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('ฝึกอีกครั้ง'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF315B43),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    super.key,
    required this.text,
    required this.index,
    required this.selected,
    required this.enabled,
    required this.correct,
    required this.showResult,
    required this.onTap,
  });

  final String text;
  final int index;
  final bool selected;
  final bool enabled;
  final bool correct;
  final bool showResult;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrectChoice = showResult && correct;
    final isWrongSelection = showResult && selected && !correct;
    final borderColor = isCorrectChoice
        ? const Color(0xFF6D9A72)
        : isWrongSelection
            ? const Color(0xFFD98B72)
            : const Color(0xFFE1E7E0);
    final backgroundColor = isCorrectChoice
        ? const Color(0xFFEAF3EA)
        : isWrongSelection
            ? const Color(0xFFFFF0EA)
            : Colors.white;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: showResult && (isCorrectChoice || isWrongSelection)
                      ? borderColor.withValues(alpha: 0.16)
                      : const Color(0xFFF0F3EF),
                  shape: BoxShape.circle,
                ),
                child: showResult && isCorrectChoice
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Color(0xFF315B43),
                      )
                    : showResult && isWrongSelection
                        ? const Icon(
                            Icons.close_rounded,
                            size: 17,
                            color: Color(0xFF9A4936),
                          )
                        : Text(
                            String.fromCharCode(65 + index),
                            style: const TextStyle(
                              color: Color(0xFF68766D),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF384A3F),
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!showResult)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9AA59B),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scenario {
  const _Scenario({
    required this.location,
    required this.story,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.explanation,
    required this.icon,
  });

  final String location;
  final String story;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final String explanation;
  final IconData icon;
}

const _scenarios = [
  _Scenario(
    location: 'อาคารฝึก · ทางเดินชั้น 2',
    story: 'คุณเห็นควันหนาทางเดินด้านหน้า แต่บันไดหนีไฟอีกฝั่งยังปลอดภัย',
    question: 'เลือกเส้นทางออกจากอาคารอย่างไร?',
    answers: [
      'ใช้บันไดหนีไฟที่ปลอดภัย และไม่ใช้ลิฟต์',
      'ใช้ลิฟต์ลงไปให้เร็วที่สุด',
      'วิ่งผ่านทางเดินที่มีควันหนา',
    ],
    correctAnswer: 0,
    explanation:
        'เลือกเส้นทางที่ไม่มีควันและใช้บันไดหนีไฟ หลีกเลี่ยงลิฟต์ระหว่างเกิดเหตุ '
        'หากเส้นทางไม่ปลอดภัย ให้ทำตามคำแนะนำของเจ้าหน้าที่',
    icon: Icons.stairs_rounded,
  ),
  _Scenario(
    location: 'อาคารฝึก · พื้นที่น้ำท่วม',
    story: 'น้ำเริ่มท่วมพื้นใกล้ปลั๊กไฟและอุปกรณ์ไฟฟ้า',
    question: 'สิ่งแรกที่ควรทำคืออะไร?',
    answers: [
      'เดินลุยน้ำไปถอดปลั๊กด้วยตัวเอง',
      'หลีกเลี่ยงน้ำและอุปกรณ์ไฟฟ้า แล้วแจ้งผู้ใหญ่หรือเจ้าหน้าที่',
      'ยืนรอดูระดับน้ำอยู่ข้างปลั๊กไฟ',
    ],
    correctAnswer: 1,
    explanation:
        'น้ำอาจนำไฟฟ้าได้ อย่าเดินลุยน้ำหรือสัมผัสอุปกรณ์ไฟฟ้า '
        'ให้แจ้งผู้รับผิดชอบและไปยังบริเวณที่ปลอดภัยตามคำแนะนำ',
    icon: Icons.electrical_services_rounded,
  ),
  _Scenario(
    location: 'อาคารฝึก · แรงสั่นสะเทือน',
    story: 'พื้นเริ่มสั่นและมีสิ่งของใกล้หน้าต่างกำลังเคลื่อน',
    question: 'ระหว่างที่ยังสั่น ควรทำอย่างไร?',
    answers: [
      'รีบวิ่งไปยืนชิดหน้าต่าง',
      'ใช้ลิฟต์ลงจากอาคารทันที',
      'หมอบ คลุมศีรษะ และยึดเกาะใต้ที่กำบังที่แข็งแรง',
    ],
    correctAnswer: 2,
    explanation:
        'ป้องกันศีรษะและหลบให้ห่างจากกระจกหรือสิ่งของที่อาจหล่น '
        'เมื่อแรงสั่นหยุดให้ประเมินทางออกและทำตามคำแนะนำของเจ้าหน้าที่',
    icon: Icons.vibration_rounded,
  ),
];
