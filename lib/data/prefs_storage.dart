import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage {
  static const _kWatchlist = 'watchlist_ids';
  static const _kWatchedMap = 'watched_map';
  static const _kIsLoggedIn = 'is_logged_in';

  Future<Set<int>> loadWatchlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_kWatchlist) ?? <String>[];
    final result = <int>{};
    for (final e in ids) {
      final id = int.tryParse(e);
      if (id != null) result.add(id);
    }
    return result;
  }

  Future<void> saveWatchlistIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kWatchlist, ids.map((e) => '$e').toList());
  }

  Future<Map<int, DateTime>> loadWatchedMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kWatchedMap);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(int.parse(k), DateTime.parse(v as String)));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveWatchedMap(Map<int, DateTime> watched) async {
    final prefs = await SharedPreferences.getInstance();
    final asStringMap = watched.map((k, v) => MapEntry('$k', v.toIso8601String()));
    await prefs.setString(_kWatchedMap, jsonEncode(asStringMap));
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool(_kIsLoggedIn, value);
    
    if (!success) {
      throw Exception('Failed to save login state');
    }
    
  
    final verify = prefs.getBool(_kIsLoggedIn);
    if (verify != value) {
      await Future.delayed(const Duration(milliseconds: 50));
      final retrySuccess = await prefs.setBool(_kIsLoggedIn, value);
      if (!retrySuccess) {
        throw Exception('Failed to save login state after retry');
      }
    }
  }
}