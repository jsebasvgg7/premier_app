import '../../../../core/models/team.dart';

class MatchModel {
  final int id;
  final int matchday;
  final DateTime date;
  final String status;
  final Team home;
  final Team away;
  final int? homeGoals;
  final int? awayGoals;

  MatchModel({
    required this.id,
    required this.matchday,
    required this.date,
    required this.status,
    required this.home,
    required this.away,
    this.homeGoals,
    this.awayGoals,
  });

  bool get isFinished => status == 'FINISHED';
  bool get hasScore => homeGoals != null && awayGoals != null;

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final score = json['score'] as Map<String, dynamic>? ?? {};
    final fullTime = score['fullTime'] as Map<String, dynamic>? ?? {};
    return MatchModel(
      id: json['id'] as int? ?? 0,
      matchday: json['matchday'] as int? ?? 0,
      date: (DateTime.tryParse(json['utcDate'] as String? ?? '') ?? DateTime.now()).toLocal(),
      status: json['status'] as String? ?? 'SCHEDULED',
      home: Team.fromJson(json['homeTeam'] as Map<String, dynamic>? ?? {}),
      away: Team.fromJson(json['awayTeam'] as Map<String, dynamic>? ?? {}),
      homeGoals: fullTime['home'] as int?,
      awayGoals: fullTime['away'] as int?,
    );
  }
}
