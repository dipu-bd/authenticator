import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/sheet.dart';

void showExportSheet({
  required BuildContext context,
  required AppTheme theme,
  required int count,
  required VoidCallback onExport,
  required VoidCallback onImport,
}) {
  showAppSheet(
    context: context,
    theme: theme,
    title: 'Export encrypted vault',
    builder: (ctx) => ExportVaultSheet(
      theme: theme,
      count: count,
      onExport: () {
        Navigator.pop(ctx);
        onExport();
      },
      onImport: () {
        Navigator.pop(ctx);
        onImport();
      },
    ),
  );
}

class ExportVaultSheet extends StatelessWidget {
  final AppTheme theme;
  final int count;
  final VoidCallback onExport;
  final VoidCallback onImport;

  const ExportVaultSheet({
    super.key,
    required this.theme,
    required this.count,
    required this.onExport,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.accentSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: AppIcon('lock', size: 19, color: theme.accent),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: theme.ui(
                      size: 13,
                      weight: FontWeight.w400,
                      color: theme.muted,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(text: 'Saves a '),
                      TextSpan(
                        text: 'bitanon-vault.enc',
                        style: theme.mono(size: 13, weight: FontWeight.w600),
                      ),
                      TextSpan(
                        text:
                            ' file with all $count accounts, encrypted with your PIN via ',
                      ),
                      TextSpan(
                        text: 'cipherlib',
                        style: theme.ui(size: 13, weight: FontWeight.w600),
                      ),
                      const TextSpan(
                        text:
                            ". Store it anywhere — it's useless without your PIN.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        PrimaryButton(
          theme: theme,
          icon: 'cloudUp',
          label: 'Export encrypted file',
          onPressed: onExport,
        ),
        const SizedBox(height: 11),
        GhostButton(
          theme: theme,
          icon: 'refresh',
          label: 'Import from file',
          onPressed: onImport,
        ),
      ],
    );
  }
}
