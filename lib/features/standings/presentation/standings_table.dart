import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/crest_image.dart';
import '../data/models/standing_item.dart';

/// Tabla reutilizada por Home (5 filas) y por la pantalla completa (20 filas).
class StandingsTable extends StatelessWidget {
  const StandingsTable({super.key, required this.items});
  final List<StandingItem> items;

  static const _bold = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.violet),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF3ECFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          _row(const Text('#', style: _bold), const Text('EQUIPO', style: _bold),
              'PJ', 'G', 'E', 'P', 'DG', 'Pts', header: true),
          const Divider(height: 8),
          for (final s in items)
            _row(
              Text('${s.position}'),
              Row(children: [
                CrestImage(s.team.crest, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(s.team.shortName, overflow: TextOverflow.ellipsis)),
              ]),
              '${s.playedGames}', '${s.won}', '${s.draw}', '${s.lost}',
              '${s.goalDifference > 0 ? '+' : ''}${s.goalDifference}', '${s.points}',
            ),
        ],
      ),
    );
  }

  Widget _row(Widget pos, Widget team, String pj, String g, String e, String p, String dg, String pts,
      {bool header = false}) {
    Widget cell(String t, {double w = 28, bool bold = false}) => SizedBox(
          width: w,
          child: Text(t,
              textAlign: TextAlign.center,
              style: header || bold ? _bold : const TextStyle(fontSize: 13)),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        SizedBox(width: 24, child: pos),
        Expanded(child: team),
        cell(pj), cell(g), cell(e), cell(p), cell(dg, w: 34), cell(pts, w: 32, bold: true),
      ]),
    );
  }
}
