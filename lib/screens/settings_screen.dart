import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../router.dart';
import '../services/backup_file.dart';
import '../services/biometric.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/pin_prompt.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'drive_screen.dart';
import 'pin_screen.dart';
import 'settings/appearance_sheet.dart';
import 'settings/export_vault_sheet.dart';
import 'settings/settings_widgets.dart';
import 'unlock_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _hide = false;
  String _lock = '30s';

  Future<void> _toggleBiometric(AppController app, AppTheme theme) async {
    if (app.biometricEnabled) {
      await app.setBiometricEnabled(false);
      return;
    }
    if (!await Biometric.instance.isAvailable()) {
      if (mounted)
        showAppToast(context, theme, 'No biometrics enrolled on this device');
      return;
    }
    if (!await Biometric.instance.authenticate(
      reason: 'Enable biometric unlock',
    ))
      return;
    await app.setBiometricEnabled(true);
    if (mounted) showAppToast(context, theme, 'Biometric unlock enabled');
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    final app = AppScope.appOf(context);

    return GradientScaffold(
      theme: theme,
      child: ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          return Column(
            children: [
              ScreenHeader(
                theme: theme,
                title: 'Settings',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 40),
                  children: [
                    SettingsGroup(
                      theme: theme,
                      header: 'Security',
                      rows: [
                        SettingsRow(
                          theme: theme,
                          icon: 'key',
                          label: 'Change PIN',
                          onTap: _changePin,
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'faceid',
                          label: 'Biometric unlock',
                          right: AppToggle(
                            theme: theme,
                            value: app.biometricEnabled,
                            onChanged: () => _toggleBiometric(app, theme),
                          ),
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'clock',
                          label: 'Auto-lock',
                          detail: _lock,
                          onTap: () {
                            setState(() {
                              _lock = _lock == '30s'
                                  ? '1 min'
                                  : _lock == '1 min'
                                  ? 'Immediately'
                                  : '30s';
                            });
                          },
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'lock',
                          label: 'Hide codes until tapped',
                          right: AppToggle(
                            theme: theme,
                            value: _hide,
                            onChanged: () => setState(() => _hide = !_hide),
                          ),
                          last: true,
                        ),
                      ],
                    ),
                    SettingsGroup(
                      theme: theme,
                      header: 'Backup',
                      rows: [
                        SettingsRow(
                          theme: theme,
                          icon: 'drive',
                          label: 'Google Drive',
                          detail: app.driveConnected ? 'On' : 'Off',
                          onTap: () => Navigator.push(
                            context,
                            appRoute(const DriveScreen()),
                          ),
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'cloudUp',
                          label: 'Export encrypted vault',
                          onTap: () => _showExport(theme, app.count),
                          last: true,
                        ),
                      ],
                    ),
                    SettingsGroup(
                      theme: theme,
                      header: 'Appearance',
                      rows: [
                        SettingsRow(
                          theme: theme,
                          icon: 'sun',
                          label: 'Theme & accent',
                          detail: theme.dark ? 'Dark' : 'Light',
                          onTap: () => showAppearanceSheet(context, theme),
                          last: true,
                        ),
                      ],
                    ),
                    SettingsGroup(
                      theme: theme,
                      header: 'About',
                      rows: [
                        SettingsRow(
                          theme: theme,
                          icon: 'shield',
                          label: 'Encryption',
                          detailWidget: _link(
                            theme,
                            'cipherlib',
                            'https://github.com/bitanon/cipherlib',
                          ),
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'clock',
                          label: 'Code engine',
                          detailWidget: _link(
                            theme,
                            'hashlib',
                            'https://github.com/bitanon/hashlib',
                          ),
                        ),
                        SettingsRow(
                          theme: theme,
                          icon: 'info',
                          label: 'Version',
                          detail: '1.0.0',
                          last: true,
                        ),
                      ],
                    ),
                    GhostButton(
                      theme: theme,
                      icon: 'lock',
                      label: 'Lock vault now',
                      color: AppTheme.danger,
                      onPressed: () {
                        app.lock();
                        Navigator.pushAndRemoveUntil(
                          context,
                          appRoute(const UnlockScreen()),
                          (r) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Text(
                        'Bitanon Authenticator · ${app.count} accounts secured',
                        style: theme.ui(
                          size: 12,
                          weight: FontWeight.w400,
                          color: theme.dim,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _link(AppTheme theme, String label, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          if (mounted) showAppToast(context, theme, 'Could not open $label');
        }
      },
      child: Text(
        label,
        style: theme.ui(size: 14, weight: FontWeight.w600, color: theme.accent),
      ),
    );
  }

  void _changePin() {
    String firstPin = '';
    Navigator.push(
      context,
      appRoute(
        PinScreen(
          mode: PinMode.create,
          onCancel: () => Navigator.pop(context),
          onComplete: (pin) async {
            firstPin = pin;
            Navigator.push(
              context,
              appRoute(
                PinScreen(
                  mode: PinMode.confirm,
                  onCancel: () => Navigator.pop(context),
                  onComplete: (pin2) async {
                    if (pin2 != firstPin) return false;
                    final app = AppScope.appOf(context);
                    final theme = AppScope.themeOf(context);
                    final nav = Navigator.of(context);
                    await app.changePin(pin2);
                    if (!mounted) return true;
                    nav.pop(); // confirm
                    nav.pop(); // create
                    showAppToast(context, theme, 'PIN updated');
                    return true;
                  },
                ),
              ),
            );
            return true;
          },
        ),
      ),
    );
  }

  void _showExport(AppTheme theme, int count) {
    showExportSheet(
      context: context,
      theme: theme,
      count: count,
      onExport: () => _exportToFile(theme),
      onImport: () => _importFromFile(theme),
    );
  }

  Future<void> _exportToFile(AppTheme theme) async {
    final app = AppScope.appOf(context);
    final blob = app.exportEncrypted();
    if (blob == null) return;
    try {
      final ok = await BackupFile.exportBlob(blob);
      if (mounted && ok) showAppToast(context, theme, 'Exported $fileLabel');
    } catch (_) {
      if (mounted) showAppToast(context, theme, 'Export failed');
    }
  }

  static const fileLabel = 'bitanon-vault.enc';

  Future<void> _importFromFile(AppTheme theme) async {
    final app = AppScope.appOf(context);
    final String? blob;
    try {
      blob = await BackupFile.importBlob();
    } catch (_) {
      if (mounted) showAppToast(context, theme, 'Could not read file');
      return;
    }
    if (blob == null) return;

    var accounts = app.decodeBackup(blob);
    if (accounts == null) {
      if (!mounted) return;
      final pin = await askBackupPin(context, theme);
      if (pin == null) return;
      accounts = app.decodeBackup(blob, pin: pin);
    }
    if (accounts == null) {
      if (mounted) showAppToast(context, theme, 'Wrong PIN or corrupt file');
      return;
    }
    final added = await app.mergeAccounts(accounts);
    if (mounted)
      showAppToast(
        context,
        theme,
        'Imported $added ${added == 1 ? 'account' : 'accounts'}',
      );
  }
}
