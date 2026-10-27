import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';

class VaultEmptyState extends StatelessWidget {
  final AppTheme theme;
  final String query;

  const VaultEmptyState({super.key, required this.theme, required this.query});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Opacity(
            opacity: 0.5,
            child: AppIcon('search', size: 40, color: theme.dim),
          ),
          const SizedBox(height: 12),
          Text(
            'No matches for "$query"',
            textAlign: TextAlign.center,
            style: theme.ui(
              size: 15,
              weight: FontWeight.w600,
              color: theme.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different name or add a new account.',
            textAlign: TextAlign.center,
            style: theme.ui(
              size: 13,
              weight: FontWeight.w400,
              color: theme.dim,
            ),
          ),
        ],
      ),
    );
  }
}
