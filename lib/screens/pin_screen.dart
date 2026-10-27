import 'package:flutter/material.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_scope.dart';
import '../widgets/gradient_scaffold.dart';
import 'pin/pin_dots.dart';
import 'pin/pin_keypad.dart';

enum PinMode { unlock, create, confirm }

class PinScreen extends StatefulWidget {
  final PinMode mode;

  /// Return false to trigger an error shake; true accepts the PIN.
  final Future<bool> Function(String pin) onComplete;
  final VoidCallback? onBiometric;
  final VoidCallback? onCancel;

  const PinScreen({
    super.key,
    required this.mode,
    required this.onComplete,
    this.onBiometric,
    this.onCancel,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _error = false;
  bool _checking = false;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  static const Map<PinMode, List<String>> _titles = {
    PinMode.unlock: ['Enter your PIN', 'Unlock Bitanon to view your codes'],
    PinMode.create: [
      'Create a PIN',
      'Choose a 6-digit code to lock your vault',
    ],
    PinMode.confirm: ['Confirm your PIN', 'Re-enter the code to confirm'],
  };

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _digit(String d) {
    if (_pin.length >= 6 || _error || _checking) return;
    setState(() => _pin += d);
    if (_pin.length == 6) {
      _checking = true;
      Future.delayed(const Duration(milliseconds: 140), () async {
        if (!mounted) return;
        final ok = await widget.onComplete(_pin);
        _checking = false;
        if (!mounted) return;
        if (!ok) {
          setState(() => _error = true);
          _shake.forward(from: 0);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _error = false;
                _pin = '';
              });
            }
          });
        } else {
          setState(() => _pin = '');
        }
      });
    }
  }

  void _delete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    final t = _titles[widget.mode]!;
    final bio = widget.mode == PinMode.unlock && widget.onBiometric != null;

    return GradientScaffold(
      theme: theme,
      safeBottom: true,
      child: Stack(
        children: [
          if (widget.onCancel != null)
            Positioned(
              top: 10,
              left: 20,
              child: GestureDetector(
                onTap: widget.onCancel,
                child: Text(
                  'Cancel',
                  style: theme.ui(
                    size: 15,
                    weight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 56, 26, 24),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: theme.accentSoft,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        alignment: Alignment.center,
                        child: AppIcon('shield', size: 32, color: theme.accent),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        t[0],
                        style: theme.ui(size: 23, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Text(
                          t[1],
                          textAlign: TextAlign.center,
                          style: theme.ui(
                            size: 14,
                            weight: FontWeight.w400,
                            color: theme.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      PinDots(
                        theme: theme,
                        pin: _pin,
                        error: _error,
                        shake: _shake,
                      ),
                    ],
                  ),
                ),
                PinKeypad(
                  theme: theme,
                  showBiometric: bio,
                  onDigit: _digit,
                  onDelete: _delete,
                  onBiometric: widget.onBiometric,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
