import 'package:material_ui/material_ui.dart';

import '../../router.dart';
import '../../state/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/screen_header.dart';
import '../settings_screen.dart';

class VaultHeader extends StatelessWidget {
  final AppTheme theme;
  final AppController app;
  final TextEditingController searchCtrl;
  final FocusNode searchFocus;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onCloudTap;

  const VaultHeader({
    super.key,
    required this.theme,
    required this.app,
    required this.searchCtrl,
    required this.searchFocus,
    required this.query,
    required this.onQueryChanged,
    required this.onCloudTap,
  });

  @override
  Widget build(BuildContext context) {
    String icon;
    Color color;
    bool spinning = false;
    if (!app.driveConnected) {
      icon = 'cloudOff';
      color = theme.dim;
    } else if (app.syncStatus == SyncStatus.syncing) {
      icon = 'refresh';
      color = theme.accent;
      spinning = true;
    } else if (app.syncStatus == SyncStatus.offline) {
      icon = 'cloud';
      color = AppTheme.danger;
    } else {
      icon = 'cloudCheck';
      color = AppTheme.success;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BITANON',
                      style: theme.ui(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: theme.dim,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Authenticator',
                      style: theme.ui(
                        size: 30,
                        weight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              SpinningCloudIcon(
                icon: icon,
                color: color,
                theme: theme,
                spinning: spinning,
                onTap: onCloudTap,
              ),
              const SizedBox(width: 9),
              IconSquareButton(
                theme: theme,
                icon: 'settings',
                onTap: () {
                  Navigator.push(context, appRoute(const SettingsScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          VaultSearchBar(
            theme: theme,
            controller: searchCtrl,
            focusNode: searchFocus,
            query: query,
            onChanged: onQueryChanged,
          ),
        ],
      ),
    );
  }
}

class VaultSearchBar extends StatelessWidget {
  final AppTheme theme;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String query;
  final ValueChanged<String> onChanged;

  const VaultSearchBar({
    super.key,
    required this.theme,
    required this.controller,
    required this.focusNode,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final focused = focusNode.hasFocus;
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: focused ? theme.accent : theme.border),
      ),
      child: Row(
        children: [
          AppIcon(
            'search',
            size: 19,
            color: focused ? theme.accent : theme.dim,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              cursorColor: theme.accent,
              style: theme.ui(size: 15.5),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search accounts',
                hintStyle: theme.ui(size: 15.5, color: theme.dim),
              ),
            ),
          ),
          if (query.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: AppIcon('x', size: 17, color: theme.dim),
            ),
        ],
      ),
    );
  }
}

/// Header cloud button with an optional continuous spin (syncing state).
class SpinningCloudIcon extends StatefulWidget {
  final String icon;
  final Color color;
  final AppTheme theme;
  final bool spinning;
  final VoidCallback onTap;

  const SpinningCloudIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.theme,
    required this.spinning,
    required this.onTap,
  });

  @override
  State<SpinningCloudIcon> createState() => _SpinningCloudIconState();
}

class _SpinningCloudIconState extends State<SpinningCloudIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.spinning) _c.repeat();
  }

  @override
  void didUpdateWidget(SpinningCloudIcon old) {
    super.didUpdateWidget(old);
    if (widget.spinning && !_c.isAnimating) {
      _c.repeat();
    } else if (!widget.spinning && _c.isAnimating) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    Widget glyph = AppIcon(widget.icon, size: 20, color: widget.color);
    if (widget.spinning) {
      glyph = RotationTransition(turns: _c, child: glyph);
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: theme.border),
        ),
        alignment: Alignment.center,
        child: glyph,
      ),
    );
  }
}
