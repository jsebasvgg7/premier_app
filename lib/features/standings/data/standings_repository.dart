import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/standings_response.dart';

class StandingsRepository {
  StandingsRepository(this._api);
  final ApiClient _api;

  Future<StandingsResponse> fetch() async {
    final json = await _api.get('/competitions/${ApiConfig.competition}/standings');
    return StandingsResponse.fromJson(json);
  }
}
