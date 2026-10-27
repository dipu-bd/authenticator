import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/segmented.dart';

class ManualAddFormFields extends StatelessWidget {
  final AppTheme theme;
  final TextEditingController issuerCtrl;
  final TextEditingController labelCtrl;
  final TextEditingController secretCtrl;
  final bool adv;
  final String alg;
  final int digits;
  final int period;
  final VoidCallback onToggleAdv;
  final ValueChanged<String> onAlgChanged;
  final ValueChanged<int> onDigitsChanged;
  final ValueChanged<int> onPeriodChanged;

  const ManualAddFormFields({
    super.key,
    required this.theme,
    required this.issuerCtrl,
    required this.labelCtrl,
    required this.secretCtrl,
    required this.adv,
    required this.alg,
    required this.digits,
    required this.period,
    required this.onToggleAdv,
    required this.onAlgChanged,
    required this.onDigitsChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(theme, 'Service / Issuer', issuerCtrl, 'e.g. GitHub'),
        _field(theme, 'Account name', labelCtrl, 'e.g. you@email.com'),
        _field(
          theme,
          'Secret key',
          secretCtrl,
          'Base32 key from the service',
          mono: true,
        ),
        GestureDetector(
          onTap: onToggleAdv,
          child: Padding(
            padding: EdgeInsets.fromLTRB(2, 4, 2, adv ? 14 : 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedRotation(
                  turns: adv ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: AppIcon('chevDown', size: 16, color: theme.accent),
                ),
                const SizedBox(width: 8),
                Text(
                  'Advanced options',
                  style: theme.ui(
                    size: 14,
                    weight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (adv) ...[
          _segField(
            theme,
            'Algorithm',
            Segmented<String>(
              theme: theme,
              value: alg,
              options: const ['SHA-1', 'SHA-256', 'SHA-512'],
              labels: const ['SHA-1', 'SHA-256', 'SHA-512'],
              onChanged: onAlgChanged,
            ),
          ),
          _segField(
            theme,
            'Digits',
            Segmented<int>(
              theme: theme,
              value: digits,
              options: const [6, 8],
              labels: const ['6', '8'],
              onChanged: onDigitsChanged,
            ),
          ),
          _segField(
            theme,
            'Period (seconds)',
            Segmented<int>(
              theme: theme,
              value: period,
              options: const [30, 60],
              labels: const ['30', '60'],
              onChanged: onPeriodChanged,
            ),
          ),
        ],
      ],
    );
  }

  Widget _field(
    AppTheme theme,
    String label,
    TextEditingController ctrl,
    String hint, {
    bool mono = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 7),
            child: Text(
              label,
              style: theme.ui(
                size: 12.5,
                weight: FontWeight.w600,
                color: theme.muted,
              ),
            ),
          ),
          TextField(
            controller: ctrl,
            cursorColor: theme.accent,
            style: mono
                ? theme.mono(size: 15, letterSpacing: 1)
                : theme.ui(size: 15.5),
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 16,
              ),
              hintText: hint,
              hintStyle: theme.ui(size: 15.5, color: theme.dim),
              filled: true,
              fillColor: theme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segField(AppTheme theme, String label, Widget seg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 7),
            child: Text(
              label,
              style: theme.ui(
                size: 12.5,
                weight: FontWeight.w600,
                color: theme.muted,
              ),
            ),
          ),
          seg,
        ],
      ),
    );
  }
}
