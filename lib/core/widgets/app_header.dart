import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../theme/app_theme.dart';
import 'circle_badge.dart';
import 'premier_logo.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.name, this.onProfileTap});
  final String name;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            CircleBadge(
              onTap: onProfileTap,
              child: const Icon(Icons.person, size: 28, color: AppTheme.aubergine),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bienvenido', style: TextStyle(fontSize: 13, height: 1.1)),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, height: 1.2),
                  ),
                ],
              ),
            ),
            const CircleBadge(
              child: PremierLogo(
                color: AppTheme.aubergine,
                size: 26,
                fallback: LucideIcons.shield,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
