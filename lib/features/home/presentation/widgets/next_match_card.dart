import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/crest_image.dart';
import '../../../matches/data/models/match_model.dart';

class NextMatchCard extends StatelessWidget {
  const NextMatchCard({super.key, required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    const white = TextStyle(color: Colors.white);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: AppTheme.headerGradient, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Próximo Partido', style: TextStyle(color: Colors.white, fontSize: 18)),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(dayMonth(match.date), style: white),
            Text(hhmm(match.date), style: white),
          ]),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _team(match.home.crest, match.home.shortName),
          const Text('—', style: TextStyle(color: Colors.white, fontSize: 24)),
          _team(match.away.crest, match.away.shortName),
        ]),
      ]),
    );
  }

  Widget _team(String crest, String name) => Column(children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.white, child: CrestImage(crest, size: 38)),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ]);
}
