import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:material_ui/material_ui.dart';

class FireRoomEscapeGame extends FlameGame {
  FireRoomEscapeGame({required this.onExitReached});

  final VoidCallback onExitReached;

  late _RoomPlayer _player;
  late Vector2 _exitPosition;
  Vector2 _moveDirection = Vector2.zero();
  bool _playerReady = false;
  bool _hasReachedExit = false;

  @override
  Color backgroundColor() => const Color(0xFF35493D);

  @override
  Future<void> onLoad() async {
    final centerX = size.x / 2;
    _exitPosition = Vector2(centerX, 28);

    add(
      RectangleComponent(
        position: Vector2(16, 16),
        size: Vector2(size.x - 32, size.y - 32),
        paint: Paint()..color = const Color(0xFFD8DDCF),
      ),
    );

    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(centerX - 48, 20),
        paint: Paint()..color = const Color(0xFF263B31),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(centerX + 48, 0),
        size: Vector2(centerX - 48, 20),
        paint: Paint()..color = const Color(0xFF263B31),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(0, 20),
        size: Vector2(18, size.y - 40),
        paint: Paint()..color = const Color(0xFF263B31),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(size.x - 18, 20),
        size: Vector2(18, size.y - 40),
        paint: Paint()..color = const Color(0xFF263B31),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(0, size.y - 20),
        size: Vector2(size.x, 20),
        paint: Paint()..color = const Color(0xFF263B31),
      ),
    );

    add(
      RectangleComponent(
        position: Vector2(centerX - 31, 0),
        size: Vector2(62, 20),
        paint: Paint()..color = const Color(0xFF87A85C),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(centerX + 20, 10),
        size: Vector2(4, 4),
        paint: Paint()..color = const Color(0xFFF2EBC9),
      ),
    );

    add(
      CircleComponent(
        position: Vector2(size.x - 68, 66),
        radius: 21,
        paint: Paint()..color = const Color(0xFFE5A15B),
      ),
    );
    add(
      CircleComponent(
        position: Vector2(size.x - 68, 66),
        radius: 10,
        paint: Paint()..color = const Color(0xFFC6533D),
      ),
    );

    _player = _RoomPlayer(
      position: Vector2(centerX, size.y - 58),
    );
    _playerReady = true;
    add(_ExitArrowGuide(player: _player, exitPosition: _exitPosition));
    add(_player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_playerReady || _hasReachedExit) return;

    _player.position.x = (_player.position.x + _moveDirection.x * 180 * dt)
        .clamp(34, size.x - 34)
        .toDouble();
    _player.position.y = (_player.position.y + _moveDirection.y * 180 * dt)
        .clamp(42, size.y - 36)
        .toDouble();
    _checkExit();
  }

  void setMoveDirection(double horizontal, double vertical) {
    if (_hasReachedExit) return;
    final magnitude = sqrt(horizontal * horizontal + vertical * vertical);
    if (magnitude > 1) {
      horizontal /= magnitude;
      vertical /= magnitude;
    }
    _moveDirection = Vector2(horizontal, vertical);
  }

  void move(double horizontal, double vertical) {
    if (!_playerReady || _hasReachedExit) return;

    _player.position.x =
        (_player.position.x + horizontal * 24)
            .clamp(34, size.x - 34)
            .toDouble();
    _player.position.y =
        (_player.position.y + vertical * 24)
            .clamp(42, size.y - 36)
            .toDouble();
    _checkExit();
  }

  void _checkExit() {
    final isAtDoor =
        (_player.position.x - _exitPosition.x).abs() < 44 &&
        _player.position.y <= 52;
    if (isAtDoor) {
      _hasReachedExit = true;
      onExitReached();
    }
  }
}

class _RoomPlayer extends PositionComponent {
  _RoomPlayer({required Vector2 position})
      : super(
          position: position,
          size: Vector2(28, 36),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 + 5),
        width: 23,
        height: 12,
      ),
      Paint()..color = const Color(0x330D2117),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2 + 3),
          width: 20,
          height: 23,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF315B43),
    );
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 - 8),
      7,
      Paint()..color = const Color(0xFFF0C29B),
    );
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 - 11),
      7,
      Paint()..color = const Color(0xFF23392D),
    );
  }
}

class _ExitArrowGuide extends Component {
  _ExitArrowGuide({
    required this.player,
    required this.exitPosition,
  });

  final _RoomPlayer player;
  final Vector2 exitPosition;

  @override
  void render(Canvas canvas) {
    final startX = player.position.x;
    final startY = player.position.y - 22;
    final dx = exitPosition.x - startX;
    final dy = exitPosition.y + 21 - startY;
    final distance = sqrt(dx * dx + dy * dy);
    if (distance < 1) return;

    final directionX = dx / distance;
    final directionY = dy / distance;
    final endX = exitPosition.x - directionX * 24;
    final endY = exitPosition.y + 21 - directionY * 24;
    final baseX = endX - directionX * 12;
    final baseY = endY - directionY * 12;
    final perpendicularX = -directionY * 7;
    final perpendicularY = directionX * 7;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      Paint()
        ..color = const Color(0xCC78964B)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(endX, endY)
        ..lineTo(baseX + perpendicularX, baseY + perpendicularY)
        ..lineTo(baseX - perpendicularX, baseY - perpendicularY)
        ..close(),
      Paint()..color = const Color(0xFF78964B),
    );
  }
}
