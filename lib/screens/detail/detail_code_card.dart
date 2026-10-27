import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/countdown.dart';

class DetailCodeCard extends StatelessWidget {
  final AppTheme theme;
  final Account account;
  final bool flash;
  final VoidCallback onTap;

  const DetailCodeCard({
    super.key,
    required this.theme,
    required this.account,
    required this.flash,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
          color: flash ? theme.accentSoft : theme.surface,
          borderRadius: BorderRadius.circular(theme.radius),
          border: Border.all(color: flash ? theme.accent : theme.border),
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: appTick,
          builder: (context, _, _) {
            final rem = Totp.remaining(account.period);
            final code = Totp.codeFor(account);
            final next = Totp.next(account);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ONE-TIME CODE',
                      style: theme.ui(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: theme.dim,
                        letterSpacing: 1.2,
                      ),
                    ),
                    CountdownRing(
                      theme: theme,
                      period: account.period,
                      size: 36,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  Totp.format(code),
                  style: theme.mono(
                    size: 48,
                    weight: FontWeight.w700,
                    letterSpacing: 5,
                    height: 1,
                    color: rem <= 5 ? AppTheme.danger : theme.text,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    AppIcon('chevR', size: 13, color: theme.dim),
                    const SizedBox(width: 7),
                    Text(
                      'Next',
                      style: theme.ui(
                        size: 12.5,
                        weight: FontWeight.w400,
                        color: theme.dim,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      Totp.format(next),
                      style: theme.mono(
                        size: 13,
                        weight: FontWeight.w500,
                        color: theme.muted,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
