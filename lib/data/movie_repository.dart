import '../models/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchAll();
}