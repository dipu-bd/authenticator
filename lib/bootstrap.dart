import 'package:flutter/material.dart';
import 'router.dart';
import 'screens/setup_flow.dart';
import 'screens/unlock_screen.dart';
import 'widgets/app_scope.dart';
import 'widgets/gradient_scaffold.dart';

/// Decides the first screen: Unlock (vault exists) vs Onboarding (first run).
class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final app = AppScope.appOf(context);
    await app.init();
    if (!mounted) return;
    final next = app.hasVault ? const UnlockScreen() : const SetupFlow();
    Navigator.pushReplacement(context, appRoute(next));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    return GradientScaffold(
      theme: theme,
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: theme.accent,
          ),
        ),
      ),
    );
  }
}
