import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/services.dart' show KeyDownEvent;
import 'package:material_ui/material_ui.dart';

import 'fire_room_game.dart';
import 'virtual_joystick.dart';

enum _MissionStage { room, runner, complete }

class RunnerDemoPage extends StatefulWidget {
  const RunnerDemoPage({super.key});

  @override
  State<RunnerDemoPage> createState() => _RunnerDemoPageState();
}

class _RunnerDemoPageState extends State<RunnerDemoPage> {
  late FireRoomEscapeGame _roomGame;
  EarthquakeEscapeGame? _runnerGame;
  _MissionStage _stage = _MissionStage.room;
  int _score = 0;
  bool? _won;
  int _runnerAttempt = 0;

  @override
  void initState() {
    super.initState();
    _createRoomGame();
  }

  void _createRoomGame() {
    _roomGame = FireRoomEscapeGame(onExitReached: _startRunner);
  }

  void _createRunnerGame() {
    _score = 0;
    _won = null;
    _runnerGame = EarthquakeEscapeGame(
      onScoreChanged: (score) {
        if (mounted) setState(() => _score = score);
      },
      onFinished: (won) {
        if (!mounted) return;
        setState(() {
          _won = won;
          if (won) _stage = _MissionStage.complete;
        });
      },
    );
  }

  void _startRunner() {
    if (!mounted || _stage != _MissionStage.room) return;
    setState(() {
      _stage = _MissionStage.runner;
      _createRunnerGame();
    });
  }

  void _restartRunner() {
    setState(() {
      _runnerAttempt++;
      _createRunnerGame();
    });
  }

  void _restartLevel() {
    setState(() {
      _stage = _MissionStage.room;
      _runnerGame = null;
      _createRoomGame();
    });
  }

  KeyEventResult _handleRoomKey(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey.keyLabel.toLowerCase();
    var horizontal = 0.0;
    var vertical = 0.0;
    if (key == 'arrow up' || key == 'w') {
      vertical = -1;
    } else if (key == 'arrow down' || key == 's') {
      vertical = 1;
    } else if (key == 'arrow left' || key == 'a') {
      horizontal = -1;
    } else if (key == 'arrow right' || key == 'd') {
      horizontal = 1;
    } else {
      return KeyEventResult.ignored;
    }

    _roomGame.move(horizontal, vertical);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_stage) {
      _MissionStage.room => 'ด่าน 1 · หาทางออก',
      _MissionStage.runner => 'ด่าน 1 · วิ่งฝ่าซาก',
      _MissionStage.complete => 'ด่าน 1 · สำเร็จ',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F1),
        titleSpacing: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF20352A),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: switch (_stage) {
              _MissionStage.room => _buildRoomMission(context),
              _MissionStage.runner => _buildRunnerMission(context),
              _MissionStage.complete => _buildCompletion(context),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoomMission(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAY 01  /  FIRE ESCAPE',
            style: TextStyle(
              color: Color(0xFFBE6A37),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'หาประตูทางออก',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF26392E),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'เหตุการณ์จำลอง: ไฟไหม้ในอาคาร เดินตามลูกศรไปยังประตู',
            style: TextStyle(
              color: Color(0xFF6D7A70),
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 17),
          _buildRoomBoard(),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.touch_app_rounded,
                color: Color(0xFF617D66),
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ลากก้านอนาล็อกเพื่อเดิน หรือใช้ปุ่ม WASD',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF647167),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'วัน 1 / 7',
                  style: TextStyle(
                    color: Color(0xFF315B43),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _buildJoystick(),
        ],
      ),
    );
  }

  Widget _buildRoomBoard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 1.55,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Focus(
              autofocus: true,
              onKeyEvent: (node, event) => _handleRoomKey(event),
              child: GameWidget<FireRoomEscapeGame>(game: _roomGame),
            ),
            Positioned(
              left: 13,
              top: 13,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xEFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFBE6A37),
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'หาทางออก',
                      style: TextStyle(
                        color: Color(0xFF35493D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 13,
              top: 13,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xEFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '↑  EXIT',
                  style: TextStyle(
                    color: Color(0xFF45623B),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoystick() {
    return Column(
      children: [
        const Text(
          'VIRTUAL JOYSTICK  ·  360°',
          style: TextStyle(
            color: Color(0xFF708075),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.9,
          ),
        ),
        const SizedBox(height: 9),
        VirtualJoystick(
          onDirectionChanged: (direction) {
            _roomGame.setMoveDirection(direction.dx, direction.dy);
          },
        ),
        const SizedBox(height: 5),
        const Text(
          'ลากเพื่อเดิน · ปล่อยเพื่อหยุด',
          style: TextStyle(color: Color(0xFF7B867E), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildRunnerMission(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAY 01  /  ESCAPE ROUTE',
            style: TextStyle(
              color: Color(0xFFBE6A37),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'วิ่งฝ่าซากไปจุดปลอดภัย',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF26392E),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'หลบสิ่งกีดขวางให้ครบ 6 ชิ้น แล้ววิ่งไปแตะประตู ESCAPE',
            style: TextStyle(color: Color(0xFF6D7A70), fontSize: 13),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'SAFE ZONE CHECKPOINT',
                  style: TextStyle(
                    color: Color(0xFF617D66),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Text(
                '$_score / 6',
                style: const TextStyle(
                  color: Color(0xFF315B43),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _buildRunnerBoard(),
          const SizedBox(height: 14),
          _buildRunnerControls(context),
        ],
      ),
    );
  }

  Widget _buildRunnerBoard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 1.75,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget<EarthquakeEscapeGame>(
              key: ValueKey(_runnerAttempt),
              game: _runnerGame!,
            ),
            if (_won == false)
              Container(
                color: const Color(0xCC17251E),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Color(0xFFFFB184),
                      size: 42,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'ภารกิจสะดุด',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ลองสังเกตสิ่งกีดขวางแล้วกระโดดอีกครั้ง',
                      style: TextStyle(color: Color(0xFFD5DED7), fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunnerControls(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _won == false
                ? 'ฝึกจังหวะกระโดดแล้วลองอีกครั้ง'
                : 'แตะสนามหรือกดปุ่มเพื่อกระโดด',
            style: const TextStyle(
              color: Color(0xFF6D7A70),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (_won == false) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            key: const Key('runner-retry-button'),
            onPressed: _restartRunner,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('ลองอีกครั้ง'),
          ),
        ],
        const SizedBox(width: 8),
        FilledButton.icon(
          key: const Key('runner-jump-button'),
          onPressed: _won == null ? _runnerGame!.jump : null,
          icon: const Icon(Icons.arrow_upward_rounded, size: 18),
          label: const Text('กระโดด'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF315B43),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletion(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF203D31), Color(0xFF315B43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(27),
            ),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDEB8B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF315B43),
                    size: 43,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'YOU ESCAPED DAY 1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'ผ่านประตูทางหนีไฟและถึงจุดปลอดภัยแล้ว',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFD4DED5), fontSize: 14),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DAY 01 COMPLETE  ·  6 DAYS TO GO',
                    style: TextStyle(
                      color: Color(0xFFE0E9CD),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('level-replay-button'),
              onPressed: _restartLevel,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('เล่นด่านนี้อีกครั้ง'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF315B43),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('level-complete-home-button'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('กลับหน้าหลัก'),
          ),
        ],
      ),
    );
  }
}

class EarthquakeEscapeGame extends FlameGame with TapCallbacks {
  EarthquakeEscapeGame({
    required this.onScoreChanged,
    required this.onFinished,
  });

  final ValueChanged<int> onScoreChanged;
  final ValueChanged<bool> onFinished;

  late RectangleComponent _ground;
  late RectangleComponent _player;
  double _groundY = 0;
  double _velocityY = 0;
  double _spawnTimer = 0;
  final Random _random = Random();
  int _score = 0;
  int _obstaclesSpawned = 0;
  EscapeDoor? _escapeDoor;
  final List<double> _obstacleHeights = [48, 64, 80, 48, 64, 80];
  bool _isFinished = false;
  static const int _obstacleGoal = 6;
  static const double _obstacleSpawnInterval = 1.6;
  static const double _gravity = 1050;
  static const double _jumpForce = -490;

  int get score => _score;
  bool get isFinished => _isFinished;

  @override
  Color backgroundColor() => const Color(0xFFB7CFCC);

  @override
  Future<void> onLoad() async {
    _obstacleHeights.shuffle(_random);
    _groundY = size.y - 42;
    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(size.x, _groundY),
        paint: Paint()..color = const Color(0xFFB7CFCC),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(0, _groundY - 5),
        size: Vector2(size.x, 6),
        paint: Paint()..color = const Color(0xFF819A8D),
      ),
    );
    _ground = RectangleComponent(
      position: Vector2(0, _groundY),
      size: Vector2(size.x, size.y - _groundY),
      paint: Paint()..color = const Color(0xFF38564A),
    );
    add(_ground);

    for (var index = 0; index < 5; index++) {
      final width = 32.0 + (index % 2) * 13;
      final height = 48.0 + (index % 3) * 15;
      add(
        RectangleComponent(
          position: Vector2(size.x * (0.32 + index * 0.15), _groundY - height),
          size: Vector2(width, height),
          paint: Paint()..color = const Color(0xFF9BB4A6),
        ),
      );
    }

    _player = RectangleComponent(
      position: Vector2(48, _groundY - 40),
      size: Vector2(30, 40),
      paint: Paint()..color = const Color(0xFFDDEB8B),
    );
    add(_player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isFinished) return;

    _velocityY += _gravity * dt;
    _player.y += _velocityY * dt;

    if (_player.y >= _groundY - _player.height) {
      _player.y = _groundY - _player.height;
      _velocityY = 0;
    }

    if (_obstaclesSpawned < _obstacleGoal) {
      _spawnTimer += dt;
      if (_spawnTimer >= _obstacleSpawnInterval) {
        _spawnTimer -= _obstacleSpawnInterval;
        _obstaclesSpawned++;
        final obstacleHeight = _obstacleHeights[_obstaclesSpawned - 1];
        add(
          DebrisObstacle(
            position: Vector2(size.x + 20, _groundY - obstacleHeight),
            size: Vector2(34, obstacleHeight),
            speed: 245 + (_score * 12),
          ),
        );
      }
    }

    for (final obstacle in children.whereType<DebrisObstacle>().toList()) {
      if (_player.toRect().overlaps(obstacle.toRect())) {
        _finish(false);
        return;
      }

      if (obstacle.x + obstacle.width < _player.x && !obstacle.passed) {
        obstacle.passed = true;
        _score++;
        onScoreChanged(_score);
        if (_score == _obstacleGoal) {
          _spawnEscapeDoor();
        }
      }
    }

    final escapeDoor = _escapeDoor;
    if (escapeDoor != null &&
        (_player.toRect().overlaps(escapeDoor.toRect()) ||
            escapeDoor.x + escapeDoor.width < _player.x)) {
      _finish(true);
    }
  }

  @override
  void onTapDown(TapDownEvent event) => jump();

  bool jump() {
    if (_isFinished || _player.y < _groundY - _player.height - 1) return false;
    _velocityY = _jumpForce;
    return true;
  }

  void _finish(bool won) {
    if (_isFinished) return;
    _isFinished = true;
    for (final obstacle in children.whereType<DebrisObstacle>().toList()) {
      obstacle.removeFromParent();
    }
    _escapeDoor?.removeFromParent();
    onFinished(won);
  }

  void _spawnEscapeDoor() {
    final door = EscapeDoor(
      position: Vector2(size.x + 36, _groundY - 66),
      size: Vector2(54, 66),
      speed: 245 + (_score * 12),
    );
    _escapeDoor = door;
    add(door);
  }
}

class DebrisObstacle extends RectangleComponent {
  DebrisObstacle({
    required super.position,
    required super.size,
    required this.speed,
  }) : super(paint: Paint()..color = const Color(0xFFBE6A37));

  final double speed;
  bool passed = false;

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
    if (x + width < 0) removeFromParent();
  }
}

class EscapeDoor extends PositionComponent {
  EscapeDoor({
    required super.position,
    required super.size,
    required this.speed,
  });

  final double speed;

  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF704B37),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(4, 4),
        size: Vector2(size.x - 8, size.y - 4),
        paint: Paint()..color = const Color(0xFF9A6849),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(9, 25),
        size: Vector2(size.x - 18, 2),
        paint: Paint()..color = const Color(0xFF714B37),
      ),
    );
    add(
      CircleComponent(
        position: Vector2(size.x - 14, size.y / 2),
        radius: 2.5,
        paint: Paint()..color = const Color(0xFFF0D38B),
      ),
    );
    add(
      TextComponent(
        text: 'ESCAPE',
        position: Vector2(size.x / 2, 13),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
  }
}
