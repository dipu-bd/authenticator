import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/account.dart';
import '../services/totp.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/brand_tile.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/meta_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'detail/account_qr_sheet.dart';
import 'detail/detail_code_card.dart';
import 'detail/edit_account_sheet.dart';

class DetailScreen extends StatefulWidget {
  final String accountId;

  const DetailScreen({super.key, required this.accountId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _reveal = false;
  bool _flash = false;

  void _copy(Account acct, AppTheme theme) {
    Clipboard.setData(ClipboardData(text: Totp.codeFor(acct)));
    setState(() => _flash = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _flash = false);
    });
    showAppToast(context, theme, '${acct.issuer} code copied');
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
          final matches = app.accounts.where((a) => a.id == widget.accountId);
          final acct = matches.isEmpty ? null : matches.first;
          if (acct == null) {
            // Account was deleted while this screen is animating away.
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              ScreenHeader(
                theme: theme,
                title: 'Account',
                onBack: () => Navigator.pop(context),
                action: IconSquareButton(
                  theme: theme,
                  icon: 'qr',
                  onTap: () => showAccountQrSheet(
                    context: context,
                    theme: theme,
                    account: acct,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 40),
                  children: [
                    _identity(theme, acct),
                    const SizedBox(height: 24),
                    DetailCodeCard(
                      theme: theme,
                      account: acct,
                      flash: _flash,
                      onTap: () => _copy(acct, theme),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      theme: theme,
                      icon: _flash ? 'check' : 'copy',
                      label: _flash ? 'Copied to clipboard' : 'Copy code',
                      onPressed: () => _copy(acct, theme),
                    ),
                    const SizedBox(height: 22),
                    _meta(theme, acct),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: GhostButton(
                            theme: theme,
                            icon: 'edit',
                            label: 'Edit',
                            onPressed: () => showEditAccountSheet(
                              context: context,
                              theme: theme,
                              account: acct,
                              onSave: (issuer, label) {
                                app.saveEdit(
                                  acct.id,
                                  issuer: issuer,
                                  label: label,
                                );
                                showAppToast(context, theme, 'Account updated');
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: GhostButton(
                            theme: theme,
                            icon: 'trash',
                            label: 'Delete',
                            color: AppTheme.danger,
                            onPressed: () {
                              app.deleteAccount(acct);
                              Navigator.pop(context);
                              showAppToast(
                                context,
                                theme,
                                '${acct.issuer} removed',
                              );
                            },
                          ),
                        ),
                      ],
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

  Widget _identity(AppTheme theme, Account acct) {
    return Column(
      children: [
        const SizedBox(height: 6),
        BrandTile(account: acct, size: 64, radius: 20),
        const SizedBox(height: 14),
        Text(acct.issuer, style: theme.ui(size: 21, weight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(
          acct.label,
          style: theme.ui(
            size: 13.5,
            weight: FontWeight.w400,
            color: theme.muted,
          ),
        ),
      ],
    );
  }

  Widget _meta(AppTheme theme, Account acct) {
    return Container(
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
            label: 'Secret key',
            value: _reveal ? acct.secret : '•••• •••• •••• ••••',
            mono: true,
            action: GestureDetector(
              onTap: () => setState(() => _reveal = !_reveal),
              child: Text(
                _reveal ? 'Hide' : 'Reveal',
                style: theme.ui(
                  size: 13,
                  weight: FontWeight.w600,
                  color: theme.accent,
                ),
              ),
            ),
          ),
          MetaRow(theme: theme, label: 'Type', value: 'Time-based (TOTP)'),
          MetaRow(theme: theme, label: 'Algorithm', value: acct.algorithm),
          MetaRow(theme: theme, label: 'Digits', value: '${acct.digits}'),
          MetaRow(
            theme: theme,
            label: 'Period',
            value: '${acct.period}s',
            last: true,
          ),
        ],
      ),
    );
  }
}
