import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';

class PinDots extends StatelessWidget {
  final AppTheme theme;
  final String pin;
  final bool error;
  final AnimationController shake;

  const PinDots({
    super.key,
    required this.theme,
    required this.pin,
    required this.error,
    required this.shake,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shake,
      builder: (context, child) {
        final dx = error
            ? math.sin(shake.value * math.pi * 8) * 8 * (1 - shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          final filled = i < pin.length;
          final c = error ? AppTheme.danger : theme.accent;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 7),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? c : Colors.transparent,
              border: Border.all(color: filled ? c : theme.borderHi, width: 2),
            ),
          );
        }),
      ),
    );
  }
}
