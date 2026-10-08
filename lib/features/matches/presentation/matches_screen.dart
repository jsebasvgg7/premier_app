import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import '../../../core/widgets/matchday_pill.dart';
import '../../../core/widgets/view_status.dart';
import 'match_tile.dart';
import 'matches_controller.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<MatchesController>();
    final matches = c.selectedMatches;

    final days = <DateTime>[];
    for (final m in matches) {
      if (!days.any((d) => sameDay(d, m.date))) days.add(m.date);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, FloatingNavBar.clearance),
      children: [
        Row(children: [
          Icon(LucideIcons.calendar, size: 24, color: AppTheme.plum),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Calendario', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          ),
          MatchdayPill(
            matchday: c.selectedMatchday,
            onPrev: () => c.selectMatchday(c.selectedMatchday - 1),
            onNext: () => c.selectMatchday(c.selectedMatchday + 1),
          ),
        ]),
        const SizedBox(height: 8),
        switch (c.status) {
          ViewStatus.loading => const Padding(
              padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
          ViewStatus.error => ErrorView(message: c.errorMessage ?? 'Error', onRetry: c.retry),
          ViewStatus.ready => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final d in days) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 0, 8),
                    child: Text(
                      dayMonth(d),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.plum),
                    ),
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
