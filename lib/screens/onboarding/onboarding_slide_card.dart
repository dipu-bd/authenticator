import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';

class SlideData {
  final String icon;
  final String title;
  final String body;

  const SlideData(this.icon, this.title, this.body);
}

const defaultSlides = [
  SlideData(
    'shield',
    'Your keys, encrypted',
    'Every secret is sealed on-device with cipherlib before it ever touches storage or the cloud.',
  ),
  SlideData(
    'qr',
    'Add in seconds',
    'Scan a QR code, paste a setup key, or batch-import everything from Google Authenticator.',
  ),
  SlideData(
    'cloudUp',
    'Backup to your Drive',
    'Keep an encrypted copy in your own Google Drive — restore on any device, anytime.',
  ),
];

class OnboardingSlideCard extends StatelessWidget {
  final AppTheme theme;
  final SlideData slide;

  const OnboardingSlideCard({
    super.key,
    required this.theme,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: theme.accentGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: theme.accent.withValues(alpha: 0.33),
                blurRadius: 44,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AppIcon(slide.icon, size: 46, color: theme.onAccent),
        ),
        const SizedBox(height: 34),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: theme.ui(
            size: 27,
            weight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            slide.body,
            textAlign: TextAlign.center,
            style: theme.ui(
              size: 15.5,
              weight: FontWeight.w400,
              color: theme.muted,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
