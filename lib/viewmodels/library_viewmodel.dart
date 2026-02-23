import 'package:flutter/foundation.dart';
import '../data/prefs_storage.dart';

class LibraryViewModel extends ChangeNotifier {
  final PrefsStorage _storage;
  LibraryViewModel(this._storage);

  bool isReady = false;

  final Set<int> watchlistIds = {};
  final Map<int, DateTime> watched = {}; // movieId -> watchedAt

  Future<void> init() async {
    final w = await _storage.loadWatchlistIds();
    final h = await _storage.loadWatchedMap();
    watchlistIds
      ..clear()
      ..addAll(w);
    watched
      ..clear()
      ..addAll(h);
    isReady = true;
    notifyListeners();
  }

  bool isInWatchlist(int id) => watchlistIds.contains(id);
  bool isWatched(int id) => watched.containsKey(id);

  Future<void> toggleWatchlist(int id) async {
    if (watchlistIds.contains(id)) {
      watchlistIds.remove(id);
    } else {
      watchlistIds.add(id);
    }
    notifyListeners();
    await _storage.saveWatchlistIds(watchlistIds);
  }

  Future<void> toggleWatched(int id) async {
    if (watched.containsKey(id)) {
      watched.remove(id);
    } else {
      watched[id] = DateTime.now();
    }
    notifyListeners();
    await _storage.saveWatchedMap(watched);
  }

  Future<void> removeFromWatchlist(int id) async {
    watchlistIds.remove(id);
    notifyListeners();
    await _storage.saveWatchlistIds(watchlistIds);
  }

  Future<void> markUnwatched(int id) async {
    watched.remove(id);
    notifyListeners();
    await _storage.saveWatchedMap(watched);
  }
}