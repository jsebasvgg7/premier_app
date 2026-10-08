import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/view_status.dart';
import '../data/matches_repository.dart';
import '../data/models/match_model.dart';

class MatchesController extends ChangeNotifier {
  MatchesController(this._repo);
  final MatchesRepository _repo;

  final Map<int, List<MatchModel>> _cache = {};

  int currentMatchday = 1;
  int selectedMatchday = 1;
  ViewStatus status = ViewStatus.loading;
  String? errorMessage;

  List<MatchModel> get selectedMatches => _cache[selectedMatchday] ?? const [];
  List<MatchModel> get currentMatches => _cache[currentMatchday] ?? const [];

  MatchModel? get nextMatch {
    for (final m in currentMatches) {
      if (!m.isFinished) return m;
    }
    return null;
  }

  List<MatchModel> get featuredDayMatches {
    final base = nextMatch ?? (currentMatches.isEmpty ? null : currentMatches.last);
    if (base == null) return const [];
    return currentMatches.where((m) => sameDay(m.date, base.date)).toList();
  }

  Future<void> init(int matchday) async {
    currentMatchday = matchday;
    selectedMatchday = matchday;
    await _load(matchday);
  }

  Future<void> selectMatchday(int matchday) async {
    if (matchday < 1 || matchday > 38) return;
    selectedMatchday = matchday;
    await _load(matchday);
  }

  Future<void> retry() => _load(selectedMatchday, force: true);

  Future<void> _load(int matchday, {bool force = false}) async {
    if (!force && _cache.containsKey(matchday)) {
      status = ViewStatus.ready;
      notifyListeners();
      return;
    }
    status = ViewStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      _cache[matchday] = await _repo.byMatchday(matchday);
      if (matchday == selectedMatchday) status = ViewStatus.ready;
    } on ApiException catch (e) {
      if (matchday == selectedMatchday) {
        errorMessage = e.message;
        status = ViewStatus.error;
      }
    } catch (_) {
      if (matchday == selectedMatchday) {
        errorMessage = 'No se pudieron leer los datos';
        status = ViewStatus.error;
      }
    }
    notifyListeners();
  }
}
