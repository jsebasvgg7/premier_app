import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/crest_image.dart';
import '../data/models/standing_item.dart';

class StandingsTable extends StatelessWidget {
  const StandingsTable({super.key, required this.items});
  final List<StandingItem> items;

  static const double _posWidth = 24;
  static const double _statWidth = 24;
  static const double _goalsWidth = 42;
  static const double _diffWidth = 32;
  static const double _pointsWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border, width: 1.4),
      ),
      child: Column(
        children: [
          _header(),
          const Divider(height: 10, color: AppTheme.border),
          for (final s in items) _row(s),
        ],
      ),
    );
  }

  Widget _header() {
    const style = TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppTheme.plum);
    Widget cell(String t, double w) =>
        SizedBox(width: w, child: Text(t, textAlign: TextAlign.center, style: style));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(children: [
        cell('#', _posWidth),
        const SizedBox(width: 6),
        const Expanded(child: Text('EQUIPO', style: style)),
        cell('PJ', _statWidth),
        cell('G', _statWidth),
        cell('E', _statWidth),
        cell('P', _statWidth),
        cell('+/-', _goalsWidth),
        cell('DG', _diffWidth),
        cell('Pts', _pointsWidth),
      ]),
    );
  }

  Widget _row(StandingItem s) {
    final leader = s.position == 1;
    TextStyle style({bool bold = false}) => TextStyle(
          fontSize: 12.5,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        );
    Widget cell(String t, double w, {bool bold = false, Color? color}) => SizedBox(
          width: w,
          child: Text(
            t,
            textAlign: TextAlign.center,
            style: style(bold: bold).copyWith(color: color),
          ),
        );
    final diff = '${s.goalDifference > 0 ? '+' : ''}${s.goalDifference}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: leader ? AppTheme.magenta.withValues(alpha: 0.09) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        cell('${s.position}', _posWidth, bold: leader, color: leader ? AppTheme.magenta : null),
        const SizedBox(width: 6),
        Expanded(
          child: Row(children: [
            CrestImage(s.team.crest, size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                s.team.displayName,
                overflow: TextOverflow.ellipsis,
                style: style(bold: leader),
              ),
            ),
          ]),
        ),
        cell('${s.playedGames}', _statWidth),
        cell('${s.won}', _statWidth),
        cell('${s.draw}', _statWidth),
        cell('${s.lost}', _statWidth),
        cell('${s.goalsFor}-${s.goalsAgainst}', _goalsWidth),
        cell(diff, _diffWidth),
        cell('${s.points}', _pointsWidth, bold: true),
      ]),
    );
  }
}
