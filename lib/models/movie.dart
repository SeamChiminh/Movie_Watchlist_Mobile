class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final String posterAsset;
  final String overview;
  final int duration;
  final String category;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.posterAsset,
    required this.overview,
    required this.duration,
    required this.category,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      posterAsset: json['posterAsset'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? 'Unknown',
    );
  }
}
