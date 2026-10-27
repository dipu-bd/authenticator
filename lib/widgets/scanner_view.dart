import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'scanner/scanner_viewfinder.dart';

/// A live QR scanner (mobile_scanner) wrapped in the design's square viewfinder
/// with accent corner brackets and an animated scan line.
class ScannerView extends StatefulWidget {
  final AppTheme theme;
  final void Function(String rawValue) onCode;

  const ScannerView({super.key, required this.theme, required this.onCode});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);
  bool _handled = false;

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final b in capture.barcodes) {
      final v = b.rawValue;
      if (v != null && v.isNotEmpty) {
        _handled = true;
        widget.onCode(v);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              fit: BoxFit.cover,
              onDetect: _onDetect,
              errorBuilder: (context, error) => _fallback(theme, error),
            ),
            Container(color: Colors.black.withValues(alpha: 0.30)),
            LayoutBuilder(
              builder: (context, c) {
                final inset = c.maxWidth * 0.18;
                final frame = c.maxWidth - inset * 2;
                return Center(
                  child: ScannerViewfinder(
                    theme: theme,
                    animation: _scan,
                    frameSize: frame,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(AppTheme theme, MobileScannerException error) {
    return Container(
      color: const Color(0xFF0C0E13),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon('qr', size: 40, color: theme.dim),
          const SizedBox(height: 12),
          Text(
            'Camera unavailable on this device.\nUse "Enter manually" instead.',
            textAlign: TextAlign.center,
            style: theme.ui(
              size: 13.5,
              weight: FontWeight.w400,
              color: theme.muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
