import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../theme/app_theme.dart';
import 'premier_logo.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const double clearance = 124;
  static const double _maxWidth = 300;
  static const double _barHeight = 62;
  static const double _lift = 34;
  static const double _inset = 22;
  static const double _bubbleSize = 56;
  static const double _bubbleRise = 6;
  static const double _notchRadius = 35;

  static final List<_Destination> _items = [
    _Destination('Inicio', (color) => PremierLogo(color: color, size: 28)),
    _Destination('Tabla', (color) => Icon(LucideIcons.trophy, size: 24, color: color)),
    _Destination('Calendario', (color) => Icon(LucideIcons.calendar, size: 24, color: color)),
    _Destination('Perfil', (color) => Icon(LucideIcons.user, size: 24, color: color)),
  ];

  @override
  Widget build(BuildContext context) {
    final width = math.min(_maxWidth, MediaQuery.sizeOf(context).width - 32);
    final slot = (width - _inset * 2) / _items.length;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: SizedBox(
            width: width,
            height: _lift + _barHeight,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: index.toDouble()),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) {
                final cx = _inset + slot * (t + 0.5);
                final nearest = math.max(0, math.min(_items.length - 1, t.round()));
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BarPainter(
                          cx: cx,
                          top: _lift,
                          barHeight: _barHeight,
                          notchRadius: _notchRadius,
                          notchRise: _bubbleRise,
                        ),
                      ),
                    ),
                    for (var i = 0; i < _items.length; i++)
                      Positioned(
                        left: _inset + slot * i,
                        top: _lift,
                        width: slot,
                        height: _barHeight,
                        child: Semantics(
                          button: true,
                          selected: i == index,
                          label: _items[i].label,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onTap(i),
                            child: Center(
                              child: Opacity(
                                opacity: math.min(1.0, (t - i).abs()),
                                child: _items[i].icon(AppTheme.aubergine),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      left: cx - _bubbleSize / 2,
                      top: _lift - _bubbleRise - _bubbleSize / 2,
                      width: _bubbleSize,
                      height: _bubbleSize,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.aubergine,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.aubergine.withValues(alpha: 0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(child: _items[nearest].icon(AppTheme.neon)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon);
  final String label;
  final Widget Function(Color color) icon;
}

class _BarPainter extends CustomPainter {
  const _BarPainter({
    required this.cx,
    required this.top,
    required this.barHeight,
    required this.notchRadius,
    required this.notchRise,
  });

  final double cx;
  final double top;
  final double barHeight;
  final double notchRadius;
  final double notchRise;

  @override
  void paint(Canvas canvas, Size size) {
    final bar = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, top, size.width, barHeight),
          Radius.circular(barHeight / 2),
        ),
      );
    final notch = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, top - notchRise), radius: notchRadius));
    final shape = Path.combine(PathOperation.difference, bar, notch);

    canvas.drawShadow(shape, AppTheme.aubergine.withValues(alpha: 0.22), 10, false);
    canvas.drawPath(shape, Paint()..color = AppTheme.card);
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.cx != cx || old.top != top || old.barHeight != barHeight;
}
