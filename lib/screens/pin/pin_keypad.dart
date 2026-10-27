import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';

class PinKeypad extends StatelessWidget {
  final AppTheme theme;
  final bool showBiometric;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;

  const PinKeypad({
    super.key,
    required this.theme,
    required this.showBiometric,
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
  });

  Widget _key(Widget child, VoidCallback? onTap, {bool flat = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: flat ? Colors.transparent : theme.surface,
              borderRadius: BorderRadius.circular(20),
              border: flat ? null : Border.all(color: theme.border),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _digit(String d) => _key(
    Text(d, style: theme.ui(size: 26, weight: FontWeight.w600)),
    () => onDigit(d),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [_digit('1'), _digit('2'), _digit('3')]),
        Row(children: [_digit('4'), _digit('5'), _digit('6')]),
        Row(children: [_digit('7'), _digit('8'), _digit('9')]),
        Row(
          children: [
            _key(
              showBiometric
                  ? AppIcon('faceid', size: 30, color: theme.accent)
                  : const SizedBox.shrink(),
              showBiometric ? onBiometric : null,
              flat: true,
            ),
            _digit('0'),
            _key(
              AppIcon('chevL', size: 26, color: theme.muted),
              onDelete,
              flat: true,
            ),
          ],
        ),
      ],
    );
  }
}
