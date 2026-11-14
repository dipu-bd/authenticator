import 'package:material_ui/material_ui.dart';
import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import 'ring_painter.dart';

/// A small progress bar + remaining seconds (card "bar" mode).
class CountdownBar extends StatelessWidget {
  final AppTheme theme;
  final int period;

  const CountdownBar({super.key, required this.theme, this.period = 30});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appTick,
      builder: (context, _, _) {
        final rem = Totp.remaining(period);
        final urgent = rem <= 5;
        final col = urgent ? AppTheme.danger : theme.accent;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: theme.border,
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAlias,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: clamp01(Totp.progress(period)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: col,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 16,
              child: Text(
                '$rem',
                style: theme.mono(
                  size: 12,
                  weight: FontWeight.w500,
                  color: urgent ? AppTheme.danger : theme.muted,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
