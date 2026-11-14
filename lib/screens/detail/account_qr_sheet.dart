import 'package:material_ui/material_ui.dart';
import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fake_qr.dart';
import '../../widgets/sheet.dart';

void showAccountQrSheet({
  required BuildContext context,
  required AppTheme theme,
  required Account account,
}) {
  showAppSheet(
    context: context,
    theme: theme,
    title: 'Account QR code',
    builder: (ctx) => AccountQrSheet(theme: theme, account: account),
  );
}

class AccountQrSheet extends StatelessWidget {
  final AppTheme theme;
  final Account account;

  const AccountQrSheet({super.key, required this.theme, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 30,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: FakeQr(seed: account.secret + account.issuer, size: 196),
        ),
        const SizedBox(height: 18),
        Text(
          account.issuer,
          style: theme.ui(size: 16, weight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          account.label,
          style: theme.ui(
            size: 13.5,
            weight: FontWeight.w400,
            color: theme.muted,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Scan this on another device to copy the account. Keep it private — it contains your secret key.',
            textAlign: TextAlign.center,
            style: theme.ui(
              size: 12.5,
              weight: FontWeight.w400,
              color: theme.dim,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
