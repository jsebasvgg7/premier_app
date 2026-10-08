import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiagonalBackdrop extends StatelessWidget {
  const DiagonalBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: 230,
        child: CustomPaint(painter: _BackdropPainter()),
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final wide = Path()
      ..moveTo(size.width * 0.40, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.62)
      ..close();
    final narrow = Path()
      ..moveTo(size.width * 0.68, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.30)
      ..close();
    canvas.drawPath(wide, Paint()..color = AppTheme.plum.withValues(alpha: 0.08));
    canvas.drawPath(narrow, Paint()..color = AppTheme.plum.withValues(alpha: 0.12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
