import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';
import 'movie_detail_screen.dart';
import '../widgets/home/home_theme.dart';
import '../widgets/popular/popular_list_item.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryName,
  });

  void _openDetail(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CatalogViewModel, LibraryViewModel>(
      builder: (context, catalog, library, _) {
        if (catalog.isLoading) {
          return const Scaffold(body: LoadingState(label: 'Loading...'));
        }

        // Filter movies by category
        final movies = catalog.allMovies.where((movie) {
          if (categoryName.toLowerCase() == 'all') {
            return true;
          }
          return movie.category.toLowerCase() == categoryName.toLowerCase();
        }).toList();

        return Scaffold(
          backgroundColor: HomeTheme.bgBottom,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _CircleBackButton(onTap: () => Navigator.of(context).pop()),
                      const Spacer(),
                      Text(
                        categoryName == 'All' ? 'All Movies' : categoryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: movies.isEmpty
                        ? const EmptyState(
                            icon: Icons.local_movies_outlined,
                            title: 'No movies',
                            message: 'No movies found in this category.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 24),
                            physics: const BouncingScrollPhysics(),
                            itemCount: movies.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, i) {
                              final m = movies[i];
                              return PopularListItem(
                                movie: m,
                                isSaved: library.isInWatchlist(m.id),
                                durationMinutes: m.duration,
                                genre: m.category,
                                type: 'Movie',
                                onTap: () => _openDetail(context, m.id),
                                onToggleHeart: () => library.toggleWatchlist(m.id),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: HomeTheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
