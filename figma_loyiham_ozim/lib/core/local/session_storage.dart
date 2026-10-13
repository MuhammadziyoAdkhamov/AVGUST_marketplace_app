import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/app_user.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('SharedPreferences main() da override qilinishi kerak');
});

final sessionStorageProvider = Provider<SessionStorage>((ref) {
  return SessionStorage(ref.watch(sharedPreferencesProvider));
});

class SessionStorage {
  SessionStorage(this._prefs);

  final SharedPreferences _prefs;
  static const _userKey = 'avgust_user';

  AppUser? readUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      _prefs.remove(_userKey);
      return null;
    } on TypeError {
      _prefs.remove(_userKey);
      return null;
    } on ArgumentError {
      _prefs.remove(_userKey);
      return null;
    }
  }

  Future<void> saveUser(AppUser user) {
    return _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clear() => _prefs.remove(_userKey);
}
