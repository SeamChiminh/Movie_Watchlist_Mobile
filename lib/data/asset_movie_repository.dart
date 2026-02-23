import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import 'movie_repository.dart';

class AssetMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> fetchAll() async {
    try {
      final raw = await rootBundle.loadString('assets/data/movies.json');
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw FormatException('Expected a list of movies, got ${decoded.runtimeType}');
      }
      final list = decoded.cast<Map<String, dynamic>>();
      return list.map((json) {
        try {
          return Movie.fromJson(json);
        } catch (e) {
          throw FormatException('Failed to parse movie: $e\nMovie data: $json');
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}