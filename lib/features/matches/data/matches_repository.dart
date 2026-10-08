import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/match_model.dart';

class MatchesRepository {
  MatchesRepository(this._api);
  final ApiClient _api;

  Future<List<MatchModel>> byMatchday(int matchday) async {
    final json = await _api.get(
      '/competitions/${ApiConfig.competition}/matches',
      query: {'matchday': '$matchday'},
    );
    final list = (json['matches'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return list.map(MatchModel.fromJson).toList()..sort((a, b) => a.date.compareTo(b.date));
  }
}
