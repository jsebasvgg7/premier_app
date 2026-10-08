class ProfileModel {
  const ProfileModel({
    this.name = '',
    this.country = '',
    this.bio = '',
    this.favoritePlayer = '',
    this.favoriteTeam = '',
  });

  final String name;
  final String country;
  final String bio;
  final String favoritePlayer;
  final String favoriteTeam;

  String get displayName => name.trim().isEmpty ? 'Invitado' : name.trim();

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      favoritePlayer: json['favoritePlayer'] as String? ?? '',
      favoriteTeam: json['favoriteTeam'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'bio': bio,
        'favoritePlayer': favoritePlayer,
        'favoriteTeam': favoriteTeam,
      };
}
