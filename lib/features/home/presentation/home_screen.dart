import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/circle_badge.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import '../../../core/widgets/matchday_pill.dart';
import '../../../core/widgets/premier_logo.dart';
import '../../../core/widgets/view_status.dart';
import '../../matches/presentation/match_tile.dart';
import '../../matches/presentation/matches_controller.dart';
import '../../standings/presentation/standings_controller.dart';
import '../../standings/presentation/standings_table.dart';
import 'widgets/next_match_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key, required this.onSeeTable, required this.onSeeMatches});
  final VoidCallback onSeeTable;
  final VoidCallback onSeeMatches;

  static const _visibleMatches = 3;

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<MatchesController>();
    final standings = context.watch<StandingsController>();
    final next = matches.nextMatch;
    final day = matches.featuredDayMatches;
    final hidden = day.length - _visibleMatches;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, FloatingNavBar.clearance),
      children: [
        if (next != null) NextMatchCard(match: next),
        const SizedBox(height: 22),
        _SectionHeader(
          title: 'Calendario',
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (day.isNotEmpty)
              Text(dayMonth(day.first.date),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 10),
            CircleBadge(
              size: 34,
              onTap: onSeeMatches,
              child: const Icon(LucideIcons.chevronRight,
                  size: 18, color: AppTheme.aubergine),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        if (day.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onSeeMatches,
              child: MatchdayPill(matchday: matches.currentMatchday),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (day.isNotEmpty) ...[
          for (final m in day.take(_visibleMatches)) MatchTile(match: m),
          if (hidden > 0)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSeeMatches,
                child: const Text('Ver más'),
              ),
            ),
        ] else if (matches.status == ViewStatus.loading)
          const _Loader()
        else if (matches.status == ViewStatus.error)
          ErrorView(
              message: matches.errorMessage ?? 'Error', onRetry: matches.retry),
        const SizedBox(height: 14),
        _SectionHeader(
          title: 'Tabla de Posiciones',
          trailing: GestureDetector(
            onTap: onSeeTable,
            child: const _LeagueLink(),
          ),
        ),
        const SizedBox(height: 12),
        switch (standings.status) {
          ViewStatus.loading => const _Loader(),
          ViewStatus.error => ErrorView(
              message: standings.errorMessage ?? 'Error',
              onRetry: standings.load),
          ViewStatus.ready => StandingsTable(
              items: standings.topFive, tabLabel: standings.seasonLabel),
        },
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.trailing});
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
        ),
      ),
      trailing,
    ]);
  }
}

class _LeagueLink extends StatelessWidget {
  const _LeagueLink();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border, width: 1.4),
      ),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        PremierLogo(
            color: AppTheme.aubergine, size: 16, fallback: LucideIcons.shield),
        SizedBox(width: 6),
        Text('Premier League',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        SizedBox(width: 2),
        Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.aubergine),
      ]),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) => const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()));
}
