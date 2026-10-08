import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../theme/app_theme.dart';
import 'gradient_ring.dart';

/// TopBar fijo: se muestra una sola vez en MainShell, sobre las tres vistas.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, this.userName = 'John Doe'});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.topBarGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Row(
            children: [
              GradientRing(child: Icon(LucideIcons.user, size: 24, color: AppTheme.ink)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bienvenido', style: TextStyle(fontSize: 13, height: 1.1)),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.2),
                    ),
                  ],
                ),
              ),
              GradientRing(
                onTap: () {},
                child: Icon(LucideIcons.bell, size: 24, color: AppTheme.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
