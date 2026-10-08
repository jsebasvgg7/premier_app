import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/widgets/view_status.dart';
import '../data/models/standing_item.dart';
import '../data/standings_repository.dart';

class StandingsController extends ChangeNotifier {
  StandingsController(this._repo);
  final StandingsRepository _repo;

  ViewStatus status = ViewStatus.loading;
  String? errorMessage;
  List<StandingItem> table = const [];
  int? currentMatchday;
  String seasonLabel = '';

  List<StandingItem> get topFive => table.take(5).toList();

  Future<void> load() async {
    status = ViewStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.fetch();
      table = res.table;
      currentMatchday = res.currentMatchday;
      seasonLabel = res.seasonLabel;
      status = ViewStatus.ready;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = ViewStatus.error;
    } catch (_) {
      errorMessage = 'No se pudieron leer los datos';
      status = ViewStatus.error;
    }
    notifyListeners();
  }
}
