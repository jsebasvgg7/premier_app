import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CircleBadge extends StatelessWidget {
  const CircleBadge({super.key, required this.child, this.size = 46, this.onTap});
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.card,
          border: Border.all(color: AppTheme.aubergine, width: 1.6),
        ),
        child: child,
      ),
    );
  }
}
