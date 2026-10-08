import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

class PremierLogo extends StatelessWidget {
  const PremierLogo({super.key, required this.color, this.size = 28});
  final Color color;
  final double size;

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
      errorBuilder: (_, __, ___) => Icon(LucideIcons.house, size: size, color: color),
    );
  }
}
