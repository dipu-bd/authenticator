import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../services/totp.dart';
import '../../state/ticker.dart';
import '../../theme/app_theme.dart';
import '../brand_tile.dart';
import 'ring_painter.dart';

/// A progress ring encircling a circular brand tile (card "logo" mode).
class AccountTile extends StatelessWidget {
  final Account account;
  final AppTheme theme;
  final double size;

  const AccountTile({
    super.key,
    required this.account,
    required this.theme,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final ring = size + 13;
    const stroke = 3.0;
    return ValueListenableBuilder<int>(
      valueListenable: appTick,
      builder: (context, _, _) {
        final urgent = Totp.remaining(account.period) <= 5;
        final col = urgent ? AppTheme.danger : theme.accent;
        return SizedBox(
          width: ring,
          height: ring,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(ring),
                painter: RingPainter(
                  progress: Totp.progress(account.period),
                  stroke: stroke,
                  track: theme.border,
                  color: col,
                ),
              ),
              BrandTile(account: account, size: size, radius: size / 2),
            ],
          ),
        );
      },
    );
  }
}
