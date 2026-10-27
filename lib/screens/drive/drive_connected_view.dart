import 'package:flutter/material.dart';
import '../../state/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/meta_row.dart';
import 'encryption_note_card.dart';

enum BackupPhase { idle, running, done }

class DriveConnectedView extends StatelessWidget {
  final AppTheme theme;
  final AppController app;
  final bool autoBackup;
  final BackupPhase phase;
  final bool busy;
  final ValueChanged<bool> onAutoBackupChanged;
  final VoidCallback onBackupNow;
  final VoidCallback onRestore;
  final VoidCallback onDisconnect;

  const DriveConnectedView({
    super.key,
    required this.theme,
    required this.app,
    required this.autoBackup,
    required this.phase,
    required this.busy,
    required this.onAutoBackupChanged,
    required this.onBackupNow,
    required this.onRestore,
    required this.onDisconnect,
  });

  String _fmtTime(DateTime? t) {
    if (t == null) return 'Never';
    final now = DateTime.now();
    if (now.difference(t).inMinutes < 1) return 'Just now';
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.hour < 12 ? 'AM' : 'PM';
    return 'Today, $h:$m $ap';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 40),
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.surface2,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: AppIcon('drive', size: 24, color: theme.accent),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connected',
                      style: theme.ui(size: 15, weight: FontWeight.w600),
                    ),
                    Text(
                      app.driveEmail ?? 'Google account',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.ui(
                        size: 13,
                        weight: FontWeight.w400,
                        color: theme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcon('checkCircle', size: 22, color: AppTheme.success),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: theme.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              MetaRow(
                theme: theme,
                label: 'Last backup',
                value: _fmtTime(app.lastBackupAt),
              ),
              MetaRow(
                theme: theme,
                label: 'Accounts',
                value: '${app.count} encrypted',
              ),
              MetaRow(
                theme: theme,
                label: 'Folder',
                value: 'appDataFolder',
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        EncryptionNoteCard(
          theme: theme,
          text:
              "Backups are end-to-end encrypted with your PIN using cipherlib. Google can't read your codes.",
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: theme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-backup',
                      style: theme.ui(size: 15, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'After every change',
                      style: theme.ui(
                        size: 12.5,
                        weight: FontWeight.w400,
                        color: theme.dim,
                      ),
                    ),
                  ],
                ),
              ),
              AppToggle(
                theme: theme,
                value: autoBackup,
                onChanged: () => onAutoBackupChanged(!autoBackup),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          theme: theme,
          icon: phase == BackupPhase.done ? 'check' : 'cloudUp',
          label: phase == BackupPhase.running
              ? 'Backing up…'
              : phase == BackupPhase.done
              ? 'Backed up'
              : 'Back up now',
          disabled: phase == BackupPhase.running,
          onPressed: onBackupNow,
        ),
        const SizedBox(height: 11),
        GhostButton(
          theme: theme,
          icon: 'refresh',
          label: busy ? 'Working…' : 'Restore from Drive',
          onPressed: busy ? null : onRestore,
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: onDisconnect,
            child: Text(
              'Disconnect Google Drive',
              style: theme.ui(
                size: 13.5,
                weight: FontWeight.w600,
                color: theme.dim,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
