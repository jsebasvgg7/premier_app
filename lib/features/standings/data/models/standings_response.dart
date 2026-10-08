import 'standing_item.dart';

class StandingsResponse {
  final int? currentMatchday;
  final String seasonLabel;
  final List<StandingItem> table;

  StandingsResponse({required this.currentMatchday, required this.seasonLabel, required this.table});

  factory StandingsResponse.fromJson(Map<String, dynamic> json) {
    final season = json['season'] as Map<String, dynamic>? ?? {};
    final start = season['startDate'] as String? ?? '';
    final end = season['endDate'] as String? ?? '';
    final label = (start.length >= 4 && end.length >= 4)
        ? 'Temp. ${start.substring(2, 4)}/${end.substring(2, 4)}'
        : '';

    final groups = (json['standings'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final total = groups.firstWhere(
      (g) => g['type'] == 'TOTAL',
      orElse: () => groups.isEmpty ? <String, dynamic>{} : groups.first,
    );
    final rows = (total['table'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    return StandingsResponse(
      currentMatchday: season['currentMatchday'] as int?,
      seasonLabel: label,
      table: rows.map(StandingItem.fromJson).toList(),
    );
  }
}
