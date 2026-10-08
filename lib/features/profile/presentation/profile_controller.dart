import 'package:flutter/foundation.dart';

import '../data/models/profile_model.dart';
import '../data/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this._repo);
  final ProfileRepository _repo;

  ProfileModel profile = const ProfileModel();
  bool loaded = false;

  Future<void> load() async {
    profile = await _repo.load();
    loaded = true;
    notifyListeners();
  }

  Future<void> save(ProfileModel value) async {
    await _repo.save(value);
    profile = value;
    notifyListeners();
  }
}
