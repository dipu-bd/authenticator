import 'package:material_ui/material_ui.dart';
import '../models/account.dart';
import '../services/otpauth.dart';
import '../services/totp.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/screen_header.dart';
import '../widgets/toast.dart';
import 'manual_add/manual_add_form.dart';
import 'manual_add/manual_add_preview.dart';

class ManualAddScreen extends StatefulWidget {
  const ManualAddScreen({super.key});

  @override
  State<ManualAddScreen> createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends State<ManualAddScreen> {
  final _issuer = TextEditingController();
  final _label = TextEditingController();
  final _secret = TextEditingController();
  bool _adv = false;
  String _alg = 'SHA-1';
  int _digits = 6;
  int _period = 30;

  @override
  void initState() {
    super.initState();
    _issuer.addListener(() => setState(() {}));
    _label.addListener(() => setState(() {}));
    _secret.addListener(_onSecretChanged);
  }

  void _onSecretChanged() {
    final text = _secret.text.trim();
    if (text.toLowerCase().startsWith('otpauth://')) {
      final acct = OtpAuth.parse(text);
      if (acct != null) {
        _secret.removeListener(_onSecretChanged);
        setState(() {
          _issuer.text = acct.issuer;
          _label.text = acct.label;
          _secret.text = acct.secret;
          _digits = acct.digits;
          _period = acct.period;
          _alg = acct.algorithm;
          _adv =
              acct.digits != 6 ||
              acct.period != 30 ||
              acct.algorithm != 'SHA-1';
        });
        _secret.addListener(_onSecretChanged);
        return;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _issuer.dispose();
    _label.dispose();
    _secret.dispose();
    super.dispose();
  }

  bool get _valid =>
      _issuer.text.trim().isNotEmpty && Totp.isValidSecret(_secret.text);

  void _add(AppTheme theme) {
    final app = AppScope.appOf(context);
    final issuer = _issuer.text.trim();
    final acct = Account(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      issuer: issuer,
      label: _label.text.trim().isEmpty ? issuer : _label.text.trim(),
      secret: _secret.text.replaceAll(RegExp(r'\s'), '').toUpperCase(),
      logo: issuer.toLowerCase(),
      color: OtpAuth.colorForIssuer(issuer),
      period: _period,
      digits: _digits,
      algorithm: _alg,
    );
    app.addAccount(acct);
    Navigator.popUntil(context, (r) => r.isFirst);
    showAppToast(context, theme, '${acct.issuer} added');
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
            title: 'Enter manually',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
              children: [
                ManualAddPreview(
                  theme: theme,
                  valid: _valid,
                  secretText: _secret.text,
                  period: _period,
                  digits: _digits,
                  alg: _alg,
                ),
                const SizedBox(height: 20),
                ManualAddFormFields(
                  theme: theme,
                  issuerCtrl: _issuer,
                  labelCtrl: _label,
                  secretCtrl: _secret,
                  adv: _adv,
                  alg: _alg,
                  digits: _digits,
                  period: _period,
                  onToggleAdv: () => setState(() => _adv = !_adv),
                  onAlgChanged: (v) => setState(() => _alg = v),
                  onDigitsChanged: (v) => setState(() => _digits = v),
                  onPeriodChanged: (v) => setState(() => _period = v),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  theme: theme,
                  icon: 'check',
                  label: 'Add account',
                  disabled: !_valid,
                  onPressed: () => _add(theme),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
