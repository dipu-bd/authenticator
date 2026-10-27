import 'package:flutter/material.dart';

import '../../router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/sheet.dart';
import '../import_screen.dart';
import '../manual_add_screen.dart';
import '../scan_screen.dart';

void openAddAccountSheet(BuildContext context, AppTheme theme) {
  showAppSheet(
    context: context,
    theme: theme,
    title: 'Add account',
    builder: (ctx) => AddAccountSheet(
      theme: theme,
      onScanQr: () {
        Navigator.pop(ctx);
        Navigator.push(context, appRoute(const ScanScreen()));
      },
      onManualAdd: () {
        Navigator.pop(ctx);
        Navigator.push(context, appRoute(const ManualAddScreen()));
      },
      onImportGa: () {
        Navigator.pop(ctx);
        Navigator.push(context, appRoute(const ImportScreen()));
      },
    ),
  );
}

class AddAccountSheet extends StatelessWidget {
  final AppTheme theme;
  final VoidCallback onScanQr;
  final VoidCallback onManualAdd;
  final VoidCallback onImportGa;

  const AddAccountSheet({
    super.key,
    required this.theme,
    required this.onScanQr,
    required this.onManualAdd,
    required this.onImportGa,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddAccountOptionTile(
          theme: theme,
          icon: 'qr',
          title: 'Scan QR code',
          subtitle: 'Point your camera at a setup code',
          onTap: onScanQr,
        ),
        AddAccountOptionTile(
          theme: theme,
          icon: 'edit',
          title: 'Enter manually',
          subtitle: 'Type a setup key or otpauth URL',
          onTap: onManualAdd,
        ),
        AddAccountOptionTile(
          theme: theme,
          icon: 'drive',
          title: 'Import from Google Authenticator',
          subtitle: 'Batch-transfer your existing accounts',
          onTap: onImportGa,
        ),
      ],
    );
  }
}

class AddAccountOptionTile extends StatelessWidget {
  final AppTheme theme;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AddAccountOptionTile({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: theme.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.accentSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: AppIcon(icon, size: 22, color: theme.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.ui(size: 15.5, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: theme.ui(
                      size: 12.5,
                      weight: FontWeight.w400,
                      color: theme.dim,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon('chevR', size: 18, color: theme.dim),
          ],
        ),
      ),
    );
  }
}
