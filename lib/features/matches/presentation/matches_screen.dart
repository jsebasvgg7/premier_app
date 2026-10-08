import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/view_status.dart';
import 'match_tile.dart';
import 'matches_controller.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<MatchesController>();
    final matches = c.selectedMatches;

    // Agrupa los partidos de la jornada por día.
    final days = <DateTime>[];
    for (final m in matches) {
      if (!days.any((d) => sameDay(d, m.date))) days.add(m.date);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const AppHeader(),
        const SizedBox(height: 16),
        const Text('Calendario', style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () => c.selectMatchday(c.selectedMatchday - 1), icon: const Icon(Icons.chevron_left)),
            Text('Jornada ${c.selectedMatchday}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            IconButton(onPressed: () => c.selectMatchday(c.selectedMatchday + 1), icon: const Icon(Icons.chevron_right)),
          ],
        ),
        switch (c.status) {
          ViewStatus.loading => const Padding(
              padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
          ViewStatus.error => ErrorView(message: c.errorMessage ?? 'Error', onRetry: c.retry),
          ViewStatus.ready => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final d in days) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(dayMonth(d), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  for (final m in matches.where((m) => sameDay(m.date, d))) MatchTile(match: m),
                ],
              ],
            ),
        },
      ],
    );
  }
}
