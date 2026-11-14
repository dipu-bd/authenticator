import 'package:material_ui/material_ui.dart';
import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/countdown.dart';

class ManualAddPreview extends StatelessWidget {
  final AppTheme theme;
  final bool valid;
  final String secretText;
  final int period;
  final int digits;
  final String alg;

  const ManualAddPreview({
    super.key,
    required this.theme,
    required this.valid,
    required this.secretText,
    required this.period,
    required this.digits,
    required this.alg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PREVIEW',
                  style: theme.ui(
                    size: 12,
                    weight: FontWeight.w600,
                    color: theme.dim,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder<int>(
                  valueListenable: appTick,
                  builder: (context, _, _) => Text(
                    valid
                        ? Totp.format(
                            Totp.preview(secretText, period, digits, alg),
                          )
                        : '••• •••',
                    style: theme.mono(
                      size: 30,
                      weight: FontWeight.w700,
                      letterSpacing: 4,
                      color: valid ? theme.text : theme.dim,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (valid)
            CountdownRing(theme: theme, period: period, size: 40)
          else
            AppIcon('clock', size: 28, color: theme.dim),
        ],
      ),
    );
  }
}
