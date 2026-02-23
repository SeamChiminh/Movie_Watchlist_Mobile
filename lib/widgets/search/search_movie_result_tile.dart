import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/home/home_theme.dart';
import '../../models/movie.dart';

class SearchMovieResultTile extends StatelessWidget {
  final Movie movie;
  final bool isSaved;
  final int durationMinutes;
  final String genre;
  final String type;
  final VoidCallback onTap;
  final VoidCallback onToggleHeart;

  const SearchMovieResultTile({
    super.key,
    required this.movie,
    required this.isSaved,
    required this.durationMinutes,
    required this.genre,
    required this.type,
    required this.onTap,
    required this.onToggleHeart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PosterWithRating(
            posterAsset: movie.posterAsset,
            rating: movie.rating,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _MetaRow(
                    icon: Icons.calendar_today_rounded,
                    text: '${movie.year}',
                  ),
                  const SizedBox(height: 12),
                  _MetaRow(
                    icon: Icons.access_time_rounded,
                    text: '$durationMinutes Minutes',
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.local_movies_rounded,
                          size: 18, color: Color(0xFF8D90A6)),
                      const SizedBox(width: 10),
                      Text(
                        genre,
                        style: const TextStyle(
                          color: Color(0xFF8D90A6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 18,
                        color: Colors.white.withOpacity(0.25),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),
          InkWell(
            onTap: onToggleHeart,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isSaved ? Colors.redAccent : Colors.white54,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterWithRating extends StatelessWidget {
  final String posterAsset;
  final double rating;

  const _PosterWithRating({
    required this.posterAsset,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              posterAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: HomeTheme.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.white54),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2B3E).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Color(0xFFFFB100)),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8D90A6)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF8D90A6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
