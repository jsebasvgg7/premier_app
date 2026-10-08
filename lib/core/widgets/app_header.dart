import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 22, backgroundColor: AppTheme.lilac, child: Icon(Icons.person, color: AppTheme.purple)),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido', style: TextStyle(fontSize: 13)),
            Text('John Doe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 28)),
      ],
    );
  }
}
