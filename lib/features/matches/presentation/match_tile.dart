import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/crest_image.dart';
import '../data/models/match_model.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    final center = match.hasScore ? '${match.homeGoals} - ${match.awayGoals}' : clockTime(match.date);
    const code = TextStyle(fontWeight: FontWeight.w700, fontSize: 17);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border, width: 1.4),
      ),
      child: Row(children: [
        Expanded(child: Text(match.home.tla, style: code)),
        CrestImage(match.home.crest, size: 30),
        SizedBox(
          width: 92,
          child: Text(
            center,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: match.hasScore ? FontWeight.w700 : FontWeight.w500,
              color: match.hasScore ? AppTheme.magenta : AppTheme.aubergine,
            ),
          ),
        ),
        CrestImage(match.away.crest, size: 30),
        Expanded(child: Text(match.away.tla, style: code, textAlign: TextAlign.right)),
      ]),
    );
  }
}
