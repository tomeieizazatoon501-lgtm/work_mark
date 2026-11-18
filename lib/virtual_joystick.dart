import 'package:material_ui/material_ui.dart';

class VirtualJoystick extends StatefulWidget {
  const VirtualJoystick({
    super.key,
    required this.onDirectionChanged,
  });

  final ValueChanged<Offset> onDirectionChanged;

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  static const double _size = 152;
  static const double _thumbSize = 58;
  static const double _travelRadius = (_size - _thumbSize) / 2 - 7;

  Offset _thumbOffset = Offset.zero;

  void _updateThumb(Offset localPosition) {
    final center = const Offset(_size / 2, _size / 2);
    final delta = localPosition - center;
    final distance = delta.distance;
    final offset = distance > _travelRadius
        ? delta * (_travelRadius / distance)
        : delta;

    setState(() => _thumbOffset = offset);
    widget.onDirectionChanged(offset / _travelRadius);
  }

  void _resetThumb() {
    setState(() => _thumbOffset = Offset.zero);
    widget.onDirectionChanged(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Virtual joystick, drag the stick in any direction',
      child: GestureDetector(
        key: const Key('room-virtual-joystick'),
        behavior: HitTestBehavior.opaque,
        onPanStart: (details) => _updateThumb(details.localPosition),
        onPanUpdate: (details) => _updateThumb(details.localPosition),
        onPanEnd: (_) => _resetThumb(),
        onPanCancel: _resetThumb,
        child: SizedBox(
          width: _size,
          height: _size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE5EBE2),
                  border: Border.all(color: const Color(0xFFD4DDD2), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14223528),
                      blurRadius: 16,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: CustomPaint(painter: _JoystickTrackPainter()),
              ),
              Transform.translate(
                offset: _thumbOffset,
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF315B43),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33223528),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Color(0xFFDDEB8B),
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoystickTrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final guidePaint = Paint()
      ..color = const Color(0xFFD0D9CD)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 43, guidePaint);
    canvas.drawLine(
      Offset(center.dx, 18),
      Offset(center.dx, size.height - 18),
      guidePaint,
    );
    canvas.drawLine(
      Offset(18, center.dy),
      Offset(size.width - 18, center.dy),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
