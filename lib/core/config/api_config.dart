import 'api_secrets.dart';

class ApiConfig {
  static const baseUrl = 'https://api.football-data.org/v4';
  static const competition = 'PL';

  static const _fromDefine = String.fromEnvironment('FOOTBALL_API_KEY');
  static const apiKey = _fromDefine != '' ? _fromDefine : footballApiKey;

  static bool get hasKey =>
      apiKey.isNotEmpty && apiKey != 'PEGA_AQUI_TU_API_KEY';
}
