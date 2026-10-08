import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../theme/app_theme.dart';

/// Barra inferior tipo "píldora" flotante. El destino activo se resalta
/// con un círculo degradado y el icono relleno.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  // Sin const ni records: así no depende de que los iconos sean constantes.
  static final List<_Destination> _items = [
    _Destination(PhosphorIconsRegular.house, PhosphorIconsFill.house, 'Inicio'),
    _Destination(
        PhosphorIconsRegular.trophy, PhosphorIconsFill.trophy, 'Tabla'),
    _Destination(PhosphorIconsRegular.calendarBlank,
        PhosphorIconsFill.calendarBlank, 'Calendario'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: AppTheme.navGradient,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: AppTheme.violet, width: 2),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.violet.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < _items.length; i++)
                _NavItem(
                  icon: i == index ? _items[i].activeIcon : _items[i].icon,
                  label: _items[i].label,
                  selected: i == index,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination {
  _Destination(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected ? AppTheme.headerGradient : null,
          ),
          child: Icon(icon,
              size: 28, color: selected ? Colors.white : AppTheme.ink),
        ),
      ),
    );
  }
}
