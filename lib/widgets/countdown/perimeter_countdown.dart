import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import 'ring_painter.dart';

/// A subtle draining line on the card's bottom edge (card "border" mode).
class PerimeterCountdown extends StatelessWidget {
  final AppTheme theme;
  final int period;
  final double radius;

  const PerimeterCountdown({
    super.key,
    required this.theme,
    this.period = 30,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final double inset = math.min(radius, 18.0) + 2;
    return ValueListenableBuilder<int>(
      valueListenable: appTick,
      builder: (context, _, _) {
        final urgent = Totp.remaining(period) <= 5;
        final col = (urgent ? AppTheme.danger : theme.accent).withValues(
          alpha: urgent ? 0.95 : 0.6,
        );
        return Positioned(
          left: inset,
          right: inset,
          bottom: 5,
          height: 2.5,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: clamp01(Totp.progress(period)),
              child: Container(
                height: 2.5,
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
