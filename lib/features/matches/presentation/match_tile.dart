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
    final center = match.hasScore ? '${match.homeGoals} - ${match.awayGoals}' : hhmm(match.date);
    const bold = TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.violet.withValues(alpha: .6)),
      ),
      child: Row(children: [
        Expanded(child: Text(match.home.tla, style: bold, textAlign: TextAlign.left)),
        CrestImage(match.home.crest, size: 28),
        SizedBox(width: 80, child: Text(center, textAlign: TextAlign.center)),
        CrestImage(match.away.crest, size: 28),
        Expanded(child: Text(match.away.tla, style: bold, textAlign: TextAlign.right)),
      ]),
    );
  }
}
