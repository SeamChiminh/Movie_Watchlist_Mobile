import 'dart:async';
import 'package:flutter/foundation.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';

class CatalogViewModel extends ChangeNotifier {
  final MovieRepository _repo;
  CatalogViewModel(this._repo);

  bool isLoading = false;
  String? error;

  List<Movie> allMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> searchResults = [];
  String query = '';

  Timer? _debounce;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      allMovies = await _repo.fetchAll();
      // "Popular" mock: first N (or sort by rating desc)
      final sorted = [...allMovies]..sort((a, b) => b.rating.compareTo(a.rating));
      popularMovies = sorted.take(8).toList();
      _applySearch();
    } catch (e) {
      error = 'Failed to load movies: ${e.toString()}';
      debugPrint('Error loading movies: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String value, {Duration debounce = const Duration(milliseconds: 400)}) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(debounce, () {
      _applySearch();
      notifyListeners();
    });
    notifyListeners();
  }

  void clearQuery() {
    query = '';
    _debounce?.cancel();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      searchResults = [];
      return;
    }
    searchResults = allMovies
        .where((m) => m.title.toLowerCase().contains(q))
        .toList();
  }

  Movie? byId(int id) {
    try {
      return allMovies.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}