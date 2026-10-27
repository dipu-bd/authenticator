import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_scope.dart';
import '../../widgets/segmented.dart';
import '../../widgets/sheet.dart';

void showAppearanceSheet(BuildContext context, AppTheme theme) {
  final controller = AppScope.of(context).themeController;
  showAppSheet(
    context: context,
    theme: theme,
    title: 'Appearance',
    builder: (ctx) => ListenableBuilder(
      listenable: controller,
      builder: (ctx, _) {
        final t = controller.theme;
        return AppearanceSheet(theme: t, controller: controller);
      },
    ),
  );
}

class AppearanceSheet extends StatelessWidget {
  final AppTheme theme;
  final ThemeController controller;

  const AppearanceSheet({
    super.key,
    required this.theme,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _apLabel(theme, 'Theme'),
        Segmented<bool>(
          theme: theme,
          value: theme.dark,
          options: const [true, false],
          labels: const ['Dark', 'Light'],
          height: 40,
          onChanged: controller.setDark,
        ),
        const SizedBox(height: 18),
        _apLabel(theme, 'Accent color'),
        Row(
          children: [
            for (final c in kAccentOptions)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => controller.setAccent(c),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: theme.accent.toARGB32() == c.toARGB32()
                            ? theme.text
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: c.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        _apLabel(theme, 'Countdown'),
        Segmented<CountdownStyle>(
          theme: theme,
          value: theme.countdown,
          options: const [
            CountdownStyle.logo,
            CountdownStyle.border,
            CountdownStyle.ring,
            CountdownStyle.bar,
          ],
          labels: const ['Logo', 'Border', 'Ring', 'Bar'],
          height: 40,
          onChanged: controller.setCountdown,
        ),
      ],
    );
  }

  Widget _apLabel(AppTheme theme, String text) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 9),
    child: Text(
      text,
      style: theme.ui(size: 12.5, weight: FontWeight.w600, color: theme.muted),
    ),
  );
}
