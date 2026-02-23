import 'package:flutter/material.dart';
import 'home_theme.dart';

class MoviePosterTile extends StatelessWidget {
  final double width;
  final double? height;
  final String title;
  final String genreText;
  final double rating;
  final String posterAsset;
  final VoidCallback onTap;

  const MoviePosterTile({
    super.key,
    required this.width,
    this.height,
    required this.title,
    required this.genreText,
    required this.rating,
    required this.posterAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image fills entire container
              Positioned.fill(
                child: Image.asset(
                  posterAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: HomeTheme.surface,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, color: Colors.white54),
                  ),
                ),
              ),

              // rating badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: HomeTheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Color(0xFFFFB100)),
                      const SizedBox(width: 6),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // bottom label 
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  color: const Color(0xE61A1B2A),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        genreText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
