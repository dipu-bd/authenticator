import 'package:material_ui/material_ui.dart';
import '../../theme/app_theme.dart';

class ScannerViewfinder extends StatelessWidget {
  final AppTheme theme;
  final Animation<double> animation;
  final double frameSize;

  const ScannerViewfinder({
    super.key,
    required this.theme,
    required this.animation,
    required this.frameSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        children: [
          ..._corners(theme),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final y =
                  Curves.easeInOut.transform(animation.value) * (frameSize - 4);
              return Positioned(
                left: 6,
                right: 6,
                top: y,
                child: Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        theme.accent,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accent,
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _corners(AppTheme theme) {
    BorderSide side() => BorderSide(color: theme.accent, width: 3);
    const len = 34.0;
    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? -2 : null,
        bottom: top ? null : -2,
        left: left ? -2 : null,
        right: left ? null : -2,
        child: Container(
          width: len,
          height: len,
          decoration: BoxDecoration(
            border: Border(
              top: top ? side() : BorderSide.none,
              bottom: top ? BorderSide.none : side(),
              left: left ? side() : BorderSide.none,
              right: left ? BorderSide.none : side(),
            ),
            borderRadius: BorderRadius.only(
              topLeft: top && left ? const Radius.circular(16) : Radius.zero,
              topRight: top && !left ? const Radius.circular(16) : Radius.zero,
              bottomLeft: !top && left
                  ? const Radius.circular(16)
                  : Radius.zero,
              bottomRight: !top && !left
                  ? const Radius.circular(16)
                  : Radius.zero,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}
