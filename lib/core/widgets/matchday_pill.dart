import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../theme/app_theme.dart';

class MatchdayPill extends StatelessWidget {
  const MatchdayPill({super.key, required this.matchday, this.onPrev, this.onNext});
  final int matchday;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: onPrev == null && onNext == null ? 14 : 2),
      decoration: BoxDecoration(
        color: AppTheme.aubergine,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPrev != null) _arrow(LucideIcons.chevronLeft, onPrev!),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              'Jornada $matchday',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          if (onNext != null) _arrow(LucideIcons.chevronRight, onNext!),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
