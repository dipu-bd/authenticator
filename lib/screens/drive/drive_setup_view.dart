import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/buttons.dart';
import 'encryption_note_card.dart';

class DriveSetupView extends StatelessWidget {
  final AppTheme theme;
  final bool busy;
  final VoidCallback onConnect;

  const DriveSetupView({
    super.key,
    required this.theme,
    required this.busy,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.accentSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: AppIcon('drive', size: 38, color: theme.accent),
          ),
          const SizedBox(height: 22),
          Text(
            'Back up to Google Drive',
            textAlign: TextAlign.center,
            style: theme.ui(size: 21, weight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              'Connect your Google account to keep an encrypted copy of your vault in a private app folder. You can restore it on any device.',
              textAlign: TextAlign.center,
              style: theme.ui(
                size: 14.5,
                weight: FontWeight.w400,
                color: theme.muted,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 22),
          EncryptionNoteCard(
            theme: theme,
            text:
                'Everything is end-to-end encrypted with your PIN using cipherlib before it leaves your device.',
          ),
          const Spacer(),
          PrimaryButton(
            theme: theme,
            icon: 'drive',
            label: busy ? 'Connecting…' : 'Connect Google Drive',
            disabled: busy,
            onPressed: onConnect,
          ),
        ],
      ),
    );
  }
}
