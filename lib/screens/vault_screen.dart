import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/account.dart';
import '../router.dart';
import '../services/drive_backup.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/account_card.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_scope.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/toast.dart';
import 'detail_screen.dart';
import 'drive_screen.dart';
import 'vault/add_account_sheet.dart';
import 'vault/vault_empty_state.dart';
import 'vault/vault_header.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  String _q = '';
  bool _sortAz = true;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _reflectDriveState());
  }

  Future<void> _reflectDriveState() async {
    final app = AppScope.appOf(context);
    if (app.driveConnected) return;
    final acc = await DriveBackup.instance.trySilent();
    if (acc != null && mounted) app.setDriveConnected(true, email: acc.email);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Account> _filtered(List<Account> accounts) {
    final s = _q.trim().toLowerCase();
    final base = s.isEmpty
        ? List<Account>.of(accounts)
        : accounts
              .where((a) => '${a.issuer} ${a.label}'.toLowerCase().contains(s))
              .toList();
    base.sort(
      (a, b) => a.issuer.toLowerCase().compareTo(b.issuer.toLowerCase()),
    );
    if (!_sortAz) {
      return base.reversed.toList();
    }
    return base;
  }

  void _copy(Account a, String code) {
    Clipboard.setData(ClipboardData(text: code));
    showAppToast(context, AppScope.themeOf(context), '${a.issuer} code copied');
  }

  Future<void> _onCloud(AppController app, AppTheme theme) async {
    if (!app.driveConnected) {
      Navigator.push(context, appRoute(const DriveScreen()));
      return;
    }
    if (app.syncStatus == SyncStatus.syncing) return;
    final blob = app.exportEncrypted();
    if (blob == null) return;
    app.setSyncStatus(SyncStatus.syncing);
    try {
      await DriveBackup.instance.upload(blob);
      app.markBackedUp();
      app.setSyncStatus(SyncStatus.synced);
      if (mounted) showAppToast(context, theme, 'Synced to Google Drive');
    } catch (_) {
      app.setSyncStatus(SyncStatus.offline);
      if (mounted) showAppToast(context, theme, 'Sync failed');
    }
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
          final list = _filtered(app.accounts);
          return Stack(
            children: [
              Column(
                children: [
                  VaultHeader(
                    theme: theme,
                    app: app,
                    searchCtrl: _searchCtrl,
                    searchFocus: _searchFocus,
                    query: _q,
                    onQueryChanged: (v) => setState(() => _q = v),
                    onCloudTap: () => _onCloud(app, theme),
                  ),
                  Expanded(child: _list(theme, list)),
                ],
              ),
              Positioned(
                right: 20,
                bottom: 38,
                child: GestureDetector(
                  onTap: () => openAddAccountSheet(context, theme),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: theme.accentGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.accent.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: AppIcon('plus', size: 28, color: theme.onAccent),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _list(AppTheme theme, List<Account> list) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${list.length} ${list.length == 1 ? 'account' : 'accounts'}',
                style: theme.ui(
                  size: 12.5,
                  weight: FontWeight.w600,
                  color: theme.dim,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _sortAz = !_sortAz),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon('sort', size: 15, color: theme.dim),
                    const SizedBox(width: 5),
                    Text(
                      _sortAz ? 'A–Z' : 'Z–A',
                      style: theme.ui(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: theme.dim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (list.isEmpty)
          VaultEmptyState(theme: theme, query: _q)
        else
          ...list.map(
            (a) => Padding(
              padding: EdgeInsets.only(bottom: theme.isCompact ? 8 : 11),
              child: AccountCard(
                account: a,
                theme: theme,
                onCopy: _copy,
                onOpen: (acct) => Navigator.push(
                  context,
                  appRoute(DetailScreen(accountId: acct.id)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
