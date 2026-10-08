class Team {
  final int id;
  final String shortName;
  final String tla;
  final String crest;

  Team({required this.id, required this.shortName, required this.tla, required this.crest});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int? ?? 0,
      shortName: json['shortName'] as String? ?? 'N/A',
      tla: json['tla'] as String? ?? '---',
      crest: json['crest'] as String? ?? '',
    );
  }
}
