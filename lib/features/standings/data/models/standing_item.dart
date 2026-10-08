import '../../../../core/models/team.dart';

class StandingItem {
  final int position;
  final Team team;
  final int playedGames;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalDifference;

  StandingItem({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalDifference,
  });

  factory StandingItem.fromJson(Map<String, dynamic> json) {
    return StandingItem(
      position: json['position'] as int? ?? 0,
      team: Team.fromJson(json['team'] as Map<String, dynamic>? ?? {}),
      playedGames: json['playedGames'] as int? ?? 0,
      won: json['won'] as int? ?? 0,
      draw: json['draw'] as int? ?? 0,
      lost: json['lost'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      goalDifference: json['goalDifference'] as int? ?? 0,
    );
  }
}
