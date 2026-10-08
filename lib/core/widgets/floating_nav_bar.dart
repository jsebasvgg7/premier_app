import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../theme/app_theme.dart';
import 'premier_logo.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const double clearance = 128;
  static const double _pillHeight = 64;
  static const double _boxHeight = 96;

  static final List<_Destination> _items = [
    _Destination('Inicio', (color) => PremierLogo(color: color, size: 30)),
    _Destination('Tabla', (color) => Icon(LucideIcons.trophy, size: 26, color: color)),
    _Destination('Calendario', (color) => Icon(LucideIcons.calendar, size: 26, color: color)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: SizedBox(
          height: _boxHeight,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _pillHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppTheme.navGradient,
                    borderRadius: BorderRadius.circular(_pillHeight / 2),
                    border: Border.all(color: AppTheme.violet, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.violet.withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    for (var i = 0; i < _items.length; i++)
                      Expanded(
                        child: _NavItem(
                          destination: _items[i],
                          selected: i == index,
                          onTap: () => onTap(i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.iconBuilder);
  final String label;
  final Widget Function(Color color) iconBuilder;
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, required this.onTap});
  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 280);
    final size = selected ? 68.0 : 48.0;
    final bottom = selected ? 12.0 : 8.0;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            width: size,
            height: size,
            margin: EdgeInsets.only(bottom: bottom),
            padding: EdgeInsets.all(selected ? 4 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.white : Colors.transparent,
              border: Border.all(
                color: selected ? AppTheme.violet : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.violet.withOpacity(selected ? 0.35 : 0),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected ? AppTheme.headerGradient : null,
              ),
              child: Center(
                child: destination.iconBuilder(selected ? Colors.white : AppTheme.ink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
