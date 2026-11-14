import 'package:material_ui/material_ui.dart';
import '../models/account.dart';
import '../services/otpauth.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/scanner_view.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'scan/scan_detected_card.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Account? _found;

  void _onCode(String raw) {
    if (_found != null) return;
    final acct = OtpAuth.parse(raw);
    if (acct != null) {
      setState(() => _found = acct);
    }
  }

  void _add(AppTheme theme) {
    AppScope.appOf(context).addAccount(_found!);
    Navigator.popUntil(context, (r) => r.isFirst);
    showAppToast(context, theme, '${_found!.issuer} added');
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    final found = _found;
    return GradientScaffold(
      theme: theme,
      child: Column(
        children: [
          ScreenHeader(
            theme: theme,
            title: 'Scan QR code',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
              children: [
                if (found == null)
                  ScannerView(theme: theme, onCode: _onCode)
                else
                  ScanDetectedPreview(theme: theme),
                const SizedBox(height: 18),
                Text(
                  found != null ? 'Code detected' : 'Point at the QR code',
                  textAlign: TextAlign.center,
                  style: theme.ui(size: 16, weight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  found != null
                      ? 'Review and confirm the account below.'
                      : 'Align the QR code from your service inside the frame.',
                  textAlign: TextAlign.center,
                  style: theme.ui(
                    size: 13.5,
                    weight: FontWeight.w400,
                    color: theme.dim,
                  ),
                ),
                const SizedBox(height: 18),
                if (found != null)
                  ScanDetectedCard(
                    theme: theme,
                    account: found,
                    onRescan: () => setState(() => _found = null),
                    onAdd: () => _add(theme),
                  )
                else
                  GhostButton(
                    theme: theme,
                    icon: 'edit',
                    label: 'Enter manually instead',
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
