import 'package:flutter/material.dart';
import '../router.dart';
import '../widgets/app_scope.dart';
import 'onboarding_screen.dart';
import 'pin_screen.dart';
import 'vault_screen.dart';

/// First-run flow: Onboarding → Create PIN → Confirm PIN → create vault → Vault.
class SetupFlow extends StatelessWidget {
  const SetupFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onDone: () => Navigator.push(context, appRoute(const CreatePinScreen())),
    );
  }
}

class CreatePinScreen extends StatelessWidget {
  const CreatePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PinScreen(
      mode: PinMode.create,
      onComplete: (pin) async {
        Navigator.push(context, appRoute(ConfirmPinScreen(firstPin: pin)));
        return true;
      },
    );
  }
}

class ConfirmPinScreen extends StatelessWidget {
  final String firstPin;

  const ConfirmPinScreen({super.key, required this.firstPin});

  @override
  Widget build(BuildContext context) {
    return PinScreen(
      mode: PinMode.confirm,
      onCancel: () => Navigator.pop(context),
      onComplete: (pin) async {
        if (pin != firstPin) return false;
        await AppScope.appOf(context).createVault(pin);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            appRoute(const VaultScreen()),
            (r) => false,
          );
        }
        return true;
      },
    );
  }
}
