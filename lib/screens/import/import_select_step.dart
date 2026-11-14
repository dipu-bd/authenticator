import 'package:material_ui/material_ui.dart';

import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';
import '../../widgets/brand_tile.dart';
import '../../widgets/buttons.dart';

class ImportSelectStep extends StatelessWidget {
  final AppTheme theme;
  final List<Account> found;
  final Set<String> selectedIds;
  final VoidCallback onToggleAll;
  final ValueChanged<Account> onToggleAccount;
  final VoidCallback onImport;

  const ImportSelectStep({
    super.key,
    required this.theme,
    required this.found,
    required this.selectedIds,
    required this.onToggleAll,
    required this.onToggleAccount,
    required this.onImport,
  });

  bool get allOn => selectedIds.length == found.length;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${found.length} ${found.length == 1 ? 'account' : 'accounts'} found',
                style: theme.ui(size: 14, weight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: onToggleAll,
                child: Text(
                  allOn ? 'Deselect all' : 'Select all',
                  style: theme.ui(
                    size: 13.5,
                    weight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...found.map((a) {
          final on = selectedIds.contains(a.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: GestureDetector(
              onTap: () => onToggleAccount(a),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(theme.radius),
                  border: Border.all(
                    color: on
                        ? theme.accent.withValues(alpha: 0.45)
                        : theme.border,
                  ),
                ),
                child: Row(
                  children: [
                    BrandTile(account: a, size: 40, radius: 12),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.issuer,
                            style: theme.ui(size: 15, weight: FontWeight.w600),
                          ),
                          Text(
                            a.label,
                            style: theme.ui(
                              size: 12.5,
                              weight: FontWeight.w400,
                              color: theme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: on ? theme.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: on ? theme.accent : theme.borderHi,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: on
                          ? AppIcon('check', size: 15, color: theme.onAccent)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 18),
        PrimaryButton(
          theme: theme,
          icon: 'check',
          label:
              'Import ${selectedIds.length} ${selectedIds.length == 1 ? 'account' : 'accounts'}',
          disabled: selectedIds.isEmpty,
          onPressed: onImport,
        ),
      ],
    );
  }
}
