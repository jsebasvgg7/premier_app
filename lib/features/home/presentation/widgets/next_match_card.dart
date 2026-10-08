import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/crest_image.dart';
import '../../../../core/widgets/premier_logo.dart';
import '../../../matches/data/models/match_model.dart';

class NextMatchCard extends StatelessWidget {
  const NextMatchCard({super.key, required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    const white = TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        gradient: AppTheme.matchGradient,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.plum.withValues(alpha: 0.6)),
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _LeagueChip(),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(dayMonth(match.date), style: white.copyWith(fontSize: 15)),
            Text(clockTime(match.date), style: white.copyWith(fontSize: 13)),
          ]),
        ]),
        const SizedBox(height: 18),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _team(match.home.crest, match.home.displayName)),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text('—', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          Expanded(child: _team(match.away.crest, match.away.displayName)),
        ]),
      ]),
    );
  }

  Widget _team(String crest, String name) => Column(children: [
        Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppTheme.plum, width: 2.5),
          ),
          child: CrestImage(crest, size: 46),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ]);
}

class _LeagueChip extends StatelessWidget {
  const _LeagueChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        PremierLogo(color: Colors.white, size: 16, fallback: Icons.shield_outlined),
        const SizedBox(width: 6),
        const Text(
          'Premier League',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
