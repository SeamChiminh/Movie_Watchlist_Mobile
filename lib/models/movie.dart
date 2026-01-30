class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final String posterAsset;
  final String overview;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.posterAsset,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String),
      year: (json['year'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      posterAsset: (json['posterAsset'] as String),
      overview: (json['overview'] as String),
    );
  }
}
