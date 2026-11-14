import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

double clamp01(double v) => v.clamp(0.0, 1.0);

/// Paints a circular progress ring (drains clockwise from 12 o'clock).
class RingPainter extends CustomPainter {
  final double progress; // 1 -> 0
  final double stroke;
  final Color track;
  final Color color;

  RingPainter({
    required this.progress,
    required this.stroke,
    required this.track,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = (math.min(size.width, size.height) - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, r, trackPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -math.pi / 2,
      2 * math.pi * clamp01(progress),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.track != track;
}
