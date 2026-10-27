import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/brand_tile.dart';
import '../../widgets/buttons.dart';

class ScanDetectedCard extends StatelessWidget {
  final AppTheme theme;
  final Account account;
  final VoidCallback onRescan;
  final VoidCallback onAdd;

  const ScanDetectedCard({
    super.key,
    required this.theme,
    required this.account,
    required this.onRescan,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: theme.border),
          ),
          child: Row(
            children: [
              BrandTile(account: account, size: 46, radius: 14),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.issuer,
                      style: theme.ui(size: 16, weight: FontWeight.w600),
                    ),
                    Text(
                      account.label,
                      style: theme.ui(
                        size: 13,
                        weight: FontWeight.w400,
                        color: theme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcon('checkCircle', size: 24, color: AppTheme.success),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GhostButton(
                theme: theme,
                icon: 'x',
                label: 'Rescan',
                onPressed: onRescan,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                theme: theme,
                icon: 'plus',
                label: 'Add account',
                onPressed: onAdd,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ScanDetectedPreview extends StatelessWidget {
  final AppTheme theme;

  const ScanDetectedPreview({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: theme.accentSoft,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        alignment: Alignment.center,
        child: AppIcon('checkCircle', size: 64, color: theme.accent),
      ),
    );
  }
}
