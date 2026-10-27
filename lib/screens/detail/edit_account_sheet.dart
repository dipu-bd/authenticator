import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_tile.dart';
import '../../widgets/buttons.dart';
import '../../widgets/sheet.dart';

void showEditAccountSheet({
  required BuildContext context,
  required AppTheme theme,
  required Account account,
  required void Function(String issuer, String label) onSave,
}) {
  showAppSheet(
    context: context,
    theme: theme,
    title: 'Edit account',
    builder: (ctx) => EditAccountForm(
      theme: theme,
      account: account,
      onSave: (issuer, label) {
        onSave(issuer, label);
        Navigator.pop(ctx);
      },
    ),
  );
}

class EditAccountForm extends StatefulWidget {
  final AppTheme theme;
  final Account account;
  final void Function(String issuer, String label) onSave;

  const EditAccountForm({
    super.key,
    required this.theme,
    required this.account,
    required this.onSave,
  });

  @override
  State<EditAccountForm> createState() => _EditAccountFormState();
}

class _EditAccountFormState extends State<EditAccountForm> {
  late final TextEditingController _issuer = TextEditingController(
    text: widget.account.issuer,
  );
  late final TextEditingController _label = TextEditingController(
    text: widget.account.label,
  );

  @override
  void dispose() {
    _issuer.dispose();
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final acct = widget.account;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            BrandTile(account: acct, size: 44, radius: 13),
            const SizedBox(width: 13),
            Text(
              '•••• •••• · ${acct.period}s · ${acct.digits} digits',
              style: theme.mono(
                size: 12.5,
                weight: FontWeight.w400,
                color: theme.dim,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _field(theme, 'Service / Issuer', _issuer, 'Issuer'),
        _field(theme, 'Account name', _label, 'you@email.com'),
        const SizedBox(height: 6),
        ListenableBuilder(
          listenable: _issuer,
          builder: (context, _) => PrimaryButton(
            theme: theme,
            icon: 'check',
            label: 'Save changes',
            disabled: _issuer.text.trim().isEmpty,
            onPressed: () =>
                widget.onSave(_issuer.text.trim(), _label.text.trim()),
          ),
        ),
      ],
    );
  }

  Widget _field(
    AppTheme theme,
    String label,
    TextEditingController ctrl,
    String hint,
  ) {
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
            style: theme.ui(size: 15.5),
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 16,
              ),
              hintText: hint,
              hintStyle: theme.ui(size: 15.5, color: theme.dim),
              filled: true,
              fillColor: theme.surface2,
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
}
