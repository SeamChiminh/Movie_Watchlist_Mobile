import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlist_mobile/data/prefs_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PrefsStorage storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    storage = PrefsStorage();
  });

  group('PrefsStorage', () {
    test('loadWatchlistIds returns empty set when nothing stored', () async {
      final ids = await storage.loadWatchlistIds();
      expect(ids, isEmpty);
    });

    test('saveWatchlistIds and loadWatchlistIds round-trip', () async {
      const ids = {1, 2, 3};
      await storage.saveWatchlistIds(ids);
      final loaded = await storage.loadWatchlistIds();
      expect(loaded, equals(ids));
    });

    test('loadWatchlistIds skips invalid entries (bug #2 fix)', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('watchlist_ids', ['1', 'abc', '2', '']);
      final loaded = await storage.loadWatchlistIds();
      expect(loaded, containsAll([1, 2]));
      expect(loaded.length, 2);
    });

    test('loadWatchedMap returns empty when nothing stored', () async {
      final map = await storage.loadWatchedMap();
      expect(map, isEmpty);
    });

    test('saveWatchedMap and loadWatchedMap round-trip', () async {
      final now = DateTime.now().toUtc();
      final watched = {1: now, 2: now.add(const Duration(days: -1))};
      await storage.saveWatchedMap(watched);
      final loaded = await storage.loadWatchedMap();
      expect(loaded.length, 2);
      expect(loaded[1]!.toIso8601String(), now.toIso8601String());
      expect(loaded[2]!.toIso8601String(), watched[2]!.toIso8601String());
    });

    test('loadWatchedMap returns empty on corrupt data (bug #1 fix)', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('watched_map', 'not valid json');
      final loaded = await storage.loadWatchedMap();
      expect(loaded, isEmpty);
    });

    test('loadWatchedMap returns empty on invalid date in json', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('watched_map', jsonEncode({'1': 'not-a-date'}));
      final loaded = await storage.loadWatchedMap();
      expect(loaded, isEmpty);
    });
  });
}
