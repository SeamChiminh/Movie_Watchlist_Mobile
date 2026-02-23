import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/home/home_theme.dart';
import '../../models/movie.dart';

class WatchlistMovieTile extends StatelessWidget {
  final Movie movie;
  final String category;
  final String type;
  final VoidCallback onTap;
  final VoidCallback onToggleHeart;

  const WatchlistMovieTile({
    super.key,
    required this.movie,
    required this.category,
    required this.type,
    required this.onTap,
    required this.onToggleHeart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: HomeTheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            _ThumbWithPlay(posterAsset: movie.posterAsset),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFFB9B9C5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                  Row(
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: Color(0xFF8D90A6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.star_rounded,
                          size: 22, color: Color(0xFFFFB100)),
                      const SizedBox(width: 6),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Color(0xFFFFB100),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Heart icon
            InkWell(
              onTap: onToggleHeart,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFFF3B30),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbWithPlay extends StatelessWidget {
  final String posterAsset;
  const _ThumbWithPlay({required this.posterAsset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 84,
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
            // subtle overlay
            Container(color: Colors.black.withOpacity(0.15)),

            // Play icon
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
