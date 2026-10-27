import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';

class SettingsGroup extends StatelessWidget {
  final AppTheme theme;
  final String header;
  final List<Widget> rows;

  const SettingsGroup({
    super.key,
    required this.theme,
    required this.header,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 9),
            child: Text(
              header,
              style: theme.ui(
                size: 12,
                weight: FontWeight.w600,
                color: theme.dim,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(theme.radius),
              border: Border.all(color: theme.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final AppTheme theme;
  final String icon;
  final String label;
  final String? detail;
  final Widget? detailWidget;
  final Widget? right;
  final VoidCallback? onTap;
  final bool last;
  final bool danger;

  const SettingsRow({
    super.key,
    required this.theme,
    required this.icon,
    required this.label,
    this.detail,
    this.detailWidget,
    this.right,
    this.onTap,
    this.last = false,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: last ? null : Border(bottom: BorderSide(color: theme.border)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: AppIcon(
                icon,
                size: 20,
                color: danger ? AppTheme.danger : theme.accent,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: theme.ui(
                  size: 15.5,
                  weight: FontWeight.w500,
                  color: danger ? AppTheme.danger : theme.text,
                ),
              ),
            ),
            ?detailWidget,
            if (detail != null)
              Text(
                detail!,
                style: theme.ui(
                  size: 14,
                  weight: FontWeight.w400,
                  color: theme.dim,
                ),
              ),
            ?right,
            if (onTap != null && right == null && detailWidget == null) ...[
              const SizedBox(width: 8),
              AppIcon('chevR', size: 17, color: theme.dim),
            ],
          ],
        ),
      ),
    );
  }
}
