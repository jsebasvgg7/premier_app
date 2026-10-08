import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

class PremierLogo extends StatelessWidget {
  const PremierLogo({
    super.key,
    required this.color,
    this.size = 28,
    this.fallback,
  });
  final Color color;
  final double size;
  final IconData? fallback;

  static const asset = 'assets/images/premier_league.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      color: color,
      colorBlendMode: BlendMode.srcIn,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(fallback ?? LucideIcons.house, size: size, color: color),
    );
  }
}
