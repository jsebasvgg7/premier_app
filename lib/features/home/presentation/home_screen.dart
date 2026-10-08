import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/view_status.dart';
import '../../matches/presentation/match_tile.dart';
import '../../matches/presentation/matches_controller.dart';
import '../../standings/presentation/standings_controller.dart';
import '../../standings/presentation/standings_table.dart';
import 'widgets/next_match_card.dart';

/// Home = resumen: próximo partido + partidos de UN día + top 5 de la tabla.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSeeTable, required this.onSeeMatches});
  final VoidCallback onSeeTable;
  final VoidCallback onSeeMatches;

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<MatchesController>();
    final standings = context.watch<StandingsController>();
    final next = matches.nextMatch;
    final day = matches.featuredDayMatches;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const AppHeader(),
        const SizedBox(height: 16),
        if (next != null) NextMatchCard(match: next),
        const SizedBox(height: 20),
        _sectionTitle('Calendario', 'Ver jornada', onSeeMatches,
            trailing: day.isEmpty ? null : dayMonth(day.first.date)),
        if (day.isNotEmpty)
          for (final m in day) MatchTile(match: m)
        else if (matches.status == ViewStatus.loading)
          const _Loader()
        else if (matches.status == ViewStatus.error)
          ErrorView(message: matches.errorMessage ?? 'Error', onRetry: matches.retry),
        const SizedBox(height: 12),
        _sectionTitle('Tabla de Posiciones', 'Ver completa', onSeeTable),
        switch (standings.status) {
          ViewStatus.loading => const _Loader(),
          ViewStatus.error => ErrorView(message: standings.errorMessage ?? 'Error', onRetry: standings.load),
          ViewStatus.ready => StandingsTable(items: standings.topFive),
        },
      ],
    );
  }

  Widget _sectionTitle(String title, String action, VoidCallback onTap, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(title, style: const TextStyle(fontSize: 20)),
        if (trailing != null) ...[
          const SizedBox(width: 10),
          Text(trailing, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
        const Spacer(),
        TextButton(onPressed: onTap, child: Text(action)),
      ]),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
}
