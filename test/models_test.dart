import 'package:flutter_test/flutter_test.dart';
import 'package:premier_app/core/models/team.dart';
import 'package:premier_app/features/matches/data/models/match_model.dart';
import 'package:premier_app/features/standings/data/models/standings_response.dart';

void main() {
  test('StandingsResponse mapea tabla, jornada y temporada', () {
    final res = StandingsResponse.fromJson({
      'season': {'startDate': '2026-08-15', 'endDate': '2027-05-23', 'currentMatchday': 7},
      'standings': [
        {
          'type': 'TOTAL',
          'table': [
            {
              'position': 1,
              'team': {'id': 65, 'shortName': 'Man City', 'tla': 'MCI', 'crest': ''},
              'playedGames': 5, 'won': 5, 'draw': 0, 'lost': 0,
              'points': 15, 'goalsFor': 10, 'goalsAgainst': 2, 'goalDifference': 8,
            }
          ],
        }
      ],
    });
    expect(res.currentMatchday, 7);
    expect(res.seasonLabel, 'Temp. 26/27');
    expect(res.table.single.team.tla, 'MCI');
    expect(res.table.single.points, 15);
    expect(res.table.single.goalsFor, 10);
    expect(res.table.single.goalsAgainst, 2);
  });

  test('MatchModel usa valores por defecto si faltan campos', () {
    final m = MatchModel.fromJson({'id': 1, 'utcDate': '2026-10-11T10:00:00Z'});
    expect(m.status, 'SCHEDULED');
    expect(m.home.shortName, 'N/A');
    expect(m.hasScore, isFalse);
    expect(m.isFinished, isFalse);
  });

  test('Team usa nombres cortos para mostrar', () {
    final t = Team.fromJson({'shortName': 'Brighton Hove'});
    expect(t.displayName, 'Brighton');
    expect(Team.fromJson({'shortName': 'Arsenal'}).displayName, 'Arsenal');
  });
}
