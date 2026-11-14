import 'package:material_ui/material_ui.dart';

import '../services/drive_backup.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/pin_prompt.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'drive/drive_connected_view.dart';
import 'drive/drive_setup_view.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({super.key});

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  bool _auto = true;
  BackupPhase _phase = BackupPhase.idle;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _silentSignIn());
  }

  Future<void> _silentSignIn() async {
    final app = AppScope.appOf(context);
    if (app.driveConnected) return;
    final acc = await DriveBackup.instance.trySilent();
    if (acc != null && mounted) app.setDriveConnected(true, email: acc.email);
  }

  Future<void> _connect(AppTheme theme, AppController app) async {
    setState(() => _busy = true);
    try {
      final acc = await DriveBackup.instance.connect();
      app.setDriveConnected(true, email: acc.email);
      final blob = app.exportEncrypted();
      if (blob != null) {
        await DriveBackup.instance.upload(blob);
        app.markBackedUp();
      }
      if (mounted) showAppToast(context, theme, 'Google Drive connected');
    } on UnsupportedError {
      if (mounted) {
        showAppToast(context, theme, 'Sign-in not supported on this platform');
      }
    } catch (_) {
      if (mounted) showAppToast(context, theme, 'Could not connect to Drive');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backupNow(AppTheme theme, AppController app) async {
    final blob = app.exportEncrypted();
    if (blob == null) return;
    setState(() => _phase = BackupPhase.running);
    try {
      await DriveBackup.instance.upload(blob);
      app.markBackedUp();
      if (mounted) {
        setState(() => _phase = BackupPhase.done);
        showAppToast(context, theme, 'Backup complete');
        Future.delayed(const Duration(milliseconds: 1600), () {
          if (mounted) setState(() => _phase = BackupPhase.idle);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _phase = BackupPhase.idle);
        showAppToast(context, theme, 'Backup failed');
      }
    }
  }

  Future<void> _restore(AppTheme theme, AppController app) async {
    setState(() => _busy = true);
    try {
      final blob = await DriveBackup.instance.download();
      if (blob == null) {
        if (mounted) showAppToast(context, theme, 'No backup found on Drive');
        return;
      }
      var accounts = app.decodeBackup(blob);
      if (accounts == null && mounted) {
        final pin = await askBackupPin(context, theme);
        if (pin == null) return;
        accounts = app.decodeBackup(blob, pin: pin);
      }
      if (accounts == null) {
        if (mounted) {
          showAppToast(context, theme, 'Wrong PIN or corrupt backup');
        }
        return;
      }
      final added = await app.mergeAccounts(accounts);
      if (mounted) {
        showAppToast(
          context,
          theme,
          'Restored $added ${added == 1 ? 'account' : 'accounts'}',
        );
      }
    } catch (_) {
      if (mounted) showAppToast(context, theme, 'Restore failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disconnect(AppTheme theme, AppController app) async {
    await DriveBackup.instance.disconnect();
    app.setDriveConnected(false);
    if (mounted) showAppToast(context, theme, 'Disconnected from Drive');
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
                title: 'Google Drive backup',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: app.driveConnected
                    ? DriveConnectedView(
                        theme: theme,
                        app: app,
                        autoBackup: _auto,
                        phase: _phase,
                        busy: _busy,
                        onAutoBackupChanged: (v) => setState(() => _auto = v),
                        onBackupNow: () => _backupNow(theme, app),
                        onRestore: () => _restore(theme, app),
                        onDisconnect: () => _disconnect(theme, app),
                      )
                    : DriveSetupView(
                        theme: theme,
                        busy: _busy,
                        onConnect: () => _connect(theme, app),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
