import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import '../../../core/widgets/premier_logo.dart';
import '../../../core/widgets/view_status.dart';
import 'standings_controller.dart';
import 'standings_table.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<StandingsController>();
    return RefreshIndicator(
      color: AppTheme.magenta,
      onRefresh: c.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, FloatingNavBar.clearance),
        children: [
          Row(children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.aubergine,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const PremierLogo(color: Colors.white, size: 30, fallback: LucideIcons.goal),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Premier League', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
              Text(c.seasonLabel),
            ]),
          ]),
          const SizedBox(height: 20),
          const Text('Tabla de Posiciones', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          switch (c.status) {
            ViewStatus.loading => const Padding(
                padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
            ViewStatus.error => ErrorView(message: c.errorMessage ?? 'Error', onRetry: c.load),
            ViewStatus.ready => StandingsTable(items: c.table, tabLabel: c.seasonLabel),
          },
        ],
      ),
    );
  }
}
