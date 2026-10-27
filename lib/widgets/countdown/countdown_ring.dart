import 'package:flutter/material.dart';

import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import 'ring_painter.dart';

/// A ring with the remaining seconds centered inside.
class CountdownRing extends StatelessWidget {
  final AppTheme theme;
  final int period;
  final double size;
  final double stroke;

  const CountdownRing({
    super.key,
    required this.theme,
    this.period = 30,
    this.size = 40,
    this.stroke = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appTick,
      builder: (context, _, _) {
        final rem = Totp.remaining(period);
        final urgent = rem <= 5;
        final col = urgent ? AppTheme.danger : theme.accent;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: RingPainter(
                  progress: Totp.progress(period),
                  stroke: stroke,
                  track: theme.border,
                  color: col,
                ),
              ),
              Text(
                '$rem',
                style: theme.mono(
                  size: size * 0.3,
                  weight: FontWeight.w600,
                  color: urgent ? AppTheme.danger : theme.muted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
