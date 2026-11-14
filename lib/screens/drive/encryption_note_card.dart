import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_icons.dart';

class EncryptionNoteCard extends StatelessWidget {
  final AppTheme theme;
  final String text;

  const EncryptionNoteCard({
    super.key,
    required this.theme,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.accentSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: AppIcon('lock', size: 19, color: theme.accent),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: theme.ui(
                size: 13,
                weight: FontWeight.w400,
                color: theme.muted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
