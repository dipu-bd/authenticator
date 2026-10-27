import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/scanner_view.dart';

class ImportScanStep extends StatelessWidget {
  final AppTheme theme;
  final ValueChanged<String> onCode;

  const ImportScanStep({super.key, required this.theme, required this.onCode});

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Open Google Authenticator',
      'Tap ⋮ → Transfer accounts → Export',
      'Scan the QR code it shows',
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: theme.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < steps.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 11),
                    child: Column(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: theme.accentSoft,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: theme.ui(
                              size: 13,
                              weight: FontWeight.w700,
                              color: theme.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          steps[i],
                          textAlign: TextAlign.center,
                          style: theme.ui(
                            size: 11.5,
                            weight: FontWeight.w400,
                            color: theme.muted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ScannerView(theme: theme, onCode: onCode),
        const SizedBox(height: 16),
        Text(
          'Looking for an export QR code…',
          textAlign: TextAlign.center,
          style: theme.ui(
            size: 13.5,
            weight: FontWeight.w400,
            color: theme.dim,
          ),
        ),
      ],
    );
  }
}
