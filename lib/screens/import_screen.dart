import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/ga_migration.dart';
import '../services/otpauth.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'import/import_scan_step.dart';
import 'import/import_select_step.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  List<Account> _found = [];
  final Set<String> _sel = {};
  bool _selectStep = false;

  void _onCode(String raw) {
    if (_selectStep) return;
    var accounts = GoogleAuthMigration.parseUri(raw);
    if (accounts.isEmpty) {
      final single = OtpAuth.parse(raw);
      if (single != null) accounts = [single];
    }
    if (accounts.isNotEmpty) {
      setState(() {
        _found = accounts;
        _sel
          ..clear()
          ..addAll(accounts.map((a) => a.id));
        _selectStep = true;
      });
    }
  }

  bool get _allOn => _sel.length == _found.length;

  Future<void> _import(AppTheme theme) async {
    final app = AppScope.appOf(context);
    final items = _found.where((a) => _sel.contains(a.id)).toList();
    final added = await app.importAccounts(items);
    if (!mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    showAppToast(
      context,
      theme,
      'Imported $added ${added == 1 ? 'account' : 'accounts'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    return GradientScaffold(
      theme: theme,
      child: Column(
        children: [
          ScreenHeader(
            theme: theme,
            title: 'Import accounts',
            subtitle: 'From Google Authenticator',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: _selectStep
                ? ImportSelectStep(
                    theme: theme,
                    found: _found,
                    selectedIds: _sel,
                    onToggleAll: () => setState(() {
                      if (_allOn) {
                        _sel.clear();
                      } else {
                        _sel
                          ..clear()
                          ..addAll(_found.map((a) => a.id));
                      }
                    }),
                    onToggleAccount: (a) => setState(() {
                      if (_sel.contains(a.id)) {
                        _sel.remove(a.id);
                      } else {
                        _sel.add(a.id);
                      }
                    }),
                    onImport: () => _import(theme),
                  )
                : ImportScanStep(theme: theme, onCode: _onCode),
          ),
        ],
      ),
    );
  }
}
