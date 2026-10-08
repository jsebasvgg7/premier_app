import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/view_status.dart';
import 'standings_controller.dart';
import 'standings_table.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<StandingsController>();
    return RefreshIndicator(
      onRefresh: c.load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(gradient: AppTheme.headerGradient, borderRadius: BorderRadius.circular(14)),
              child: Icon(PhosphorIconsFill.soccerBall, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Premier League', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(c.seasonLabel),
            ]),
          ]),
          const SizedBox(height: 16),
          const Text('Tabla de Posiciones', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          switch (c.status) {
            ViewStatus.loading => const Padding(
                padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
            ViewStatus.error => ErrorView(message: c.errorMessage ?? 'Error', onRetry: c.load),
            ViewStatus.ready => StandingsTable(items: c.table),
          },
        ],
      ),
    );
  }
}
