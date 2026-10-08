class ApiConfig {
  static const baseUrl = 'https://api.football-data.org/v4';
  static const competition = 'PL';

  /// Se pasa al compilar: flutter run --dart-define=FOOTBALL_API_KEY=tu_clave
  static const apiKey = String.fromEnvironment('FOOTBALL_API_KEY');
}
