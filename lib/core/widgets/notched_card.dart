import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tarjeta con esquina superior derecha recortada (pestaña) para una etiqueta.
class NotchedCard extends StatelessWidget {
  const NotchedCard({
    super.key,
    required this.child,
    this.tabLabel,
    this.dark = false,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final String? tabLabel;
  final bool dark;
  final EdgeInsets padding;

  static const double tabW = 112, tabH = 34;

  @override
  Widget build(BuildContext context) {
    final hasTab = tabLabel != null && tabLabel!.isNotEmpty;
    return CustomPaint(
      painter: _NotchPainter(dark: dark, notch: hasTab),
      child: Stack(children: [
        Padding(padding: padding, child: child),
        if (hasTab)
          Positioned(
            top: 0,
            right: 0,
            width: tabW,
            height: tabH,
            child: Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                  child: Text(tabLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppTheme.magenta, shape: BoxShape.circle),
                ),
              ]),
            ),
          ),
      ]),
    );
  }
}

class _NotchPainter extends CustomPainter {
  _NotchPainter({required this.dark, required this.notch});
  final bool dark, notch;

  @override
  void paint(Canvas canvas, Size s) {
    const r = 28.0, q = 14.0;
    final w = s.width, h = s.height;
    final nx = w - NotchedCard.tabW, nh = NotchedCard.tabH;
    final p = Path()..moveTo(r, 0);
    if (notch) {
      p
        ..lineTo(nx - q, 0)
        ..quadraticBezierTo(nx, 0, nx, q)
        ..lineTo(nx, nh - q)
        ..quadraticBezierTo(nx, nh, nx + q, nh)
        ..lineTo(w - r, nh)
        ..quadraticBezierTo(w, nh, w, nh + r);
    } else {
      p
        ..lineTo(w - r, 0)
        ..quadraticBezierTo(w, 0, w, r);
    }
    p
      ..lineTo(w, h - r)
      ..quadraticBezierTo(w, h, w - r, h)
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, h - r)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();

    canvas.drawShadow(p, AppTheme.aubergine.withValues(alpha: dark ? 0.55 : 0.25), dark ? 14 : 8, false);
    final rect = Offset.zero & s;
    final paint = Paint()
      ..shader = (dark
              ? AppTheme.darkGradient
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF7F4FA)],
                ))
          .createShader(rect);
    canvas.drawPath(p, paint);
    if (!dark) {
      canvas.drawPath(
        p,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = AppTheme.border.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NotchPainter o) => o.dark != dark || o.notch != notch;
}

class DashedLine extends StatelessWidget {
  const DashedLine({super.key, this.color = Colors.white24});
  final Color color;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_, c) {
        final n = (c.maxWidth / 8).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(n, (_) => Container(width: 4, height: 1, color: color)),
        );
      });
}
