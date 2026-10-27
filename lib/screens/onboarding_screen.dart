import 'package:flutter/material.dart';

import '../widgets/app_scope.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_scaffold.dart';
import 'onboarding/onboarding_slide_card.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppScope.themeOf(context);
    final s = defaultSlides[_i];
    final last = _i == defaultSlides.length - 1;

    return GradientScaffold(
      theme: theme,
      safeBottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_i),
                      child: OnboardingSlideCard(theme: theme, slide: s),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(defaultSlides.length, (k) {
                final active = k == _i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? theme.accent : theme.borderHi,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 26),
            PrimaryButton(
              theme: theme,
              label: last ? 'Get started' : 'Continue',
              onPressed: () {
                if (last) {
                  widget.onDone();
                } else {
                  setState(() => _i++);
                }
              },
            ),
            SizedBox(
              height: 48,
              child: last
                  ? null
                  : Center(
                      child: GestureDetector(
                        onTap: widget.onDone,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            'Skip',
                            style: theme.ui(
                              size: 14,
                              weight: FontWeight.w600,
                              color: theme.dim,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
