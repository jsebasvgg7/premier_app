import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/crest_image.dart';
import '../../../../core/widgets/notched_card.dart';
import '../../../matches/data/models/match_model.dart';

class NextMatchCard extends StatelessWidget {
  const NextMatchCard({super.key, required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    return NotchedCard(
      dark: true,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      child: Column(children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PRÓXIMO PARTIDO',
              style: TextStyle(
                color: AppTheme.aubergine,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const Spacer(),
          const Icon(LucideIcons.calendar, size: 14, color: Colors.white60),
          const SizedBox(width: 6),
          Text(
            dayMonth(match.date),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ]),
        const SizedBox(height: 26),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 80,
                child: _team(match.home.crest, match.home.displayName)),
            SizedBox(width: 112, child: _center()),
            SizedBox(
                width: 80,
                child: _team(match.away.crest, match.away.displayName)),
          ]),
        ),
      ]),
    );
  }

  Widget _center() => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(children: [
          const Text('VS',
              style: TextStyle(
                  color: Colors.white54, fontSize: 11, letterSpacing: 3)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              clockTime(match.date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white38),
            ),
            child: Text(
              'Jornada ${match.matchday}',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ]),
      );

  Widget _team(String crest, String name) => Column(children: [
        Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: CrestImage(crest, size: 34),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ]);
}
