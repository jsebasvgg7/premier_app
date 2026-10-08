import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Círculo con borde degradado (avatar y campana del mockup).
class GradientRing extends StatelessWidget {
  const GradientRing({super.key, required this.child, this.size = 48, this.onTap});
  final Widget child;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.headerGradient),
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
