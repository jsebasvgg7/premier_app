import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/profile_model.dart';

class ProfileRepository {
  static const _key = 'user_profile';

  Future<ProfileModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const ProfileModel();
    try {
      return ProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const ProfileModel();
    }
  }

  Future<void> save(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }
}
