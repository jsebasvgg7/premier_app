import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

/// Algunos escudos de la API son .svg y otros .png.
class CrestImage extends StatelessWidget {
  const CrestImage(this.url, {super.key, this.size = 28});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(LucideIcons.shield, size: size);
    if (url.isEmpty) return fallback;
    final image = url.toLowerCase().endsWith('.svg')
        ? SvgPicture.network(url, width: size, height: size)
        : Image.network(url, width: size, height: size, errorBuilder: (_, __, ___) => fallback);
    return SizedBox(width: size, height: size, child: image);
  }
}
