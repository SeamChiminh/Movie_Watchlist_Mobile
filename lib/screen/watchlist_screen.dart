import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/watchlist/watchlist_movie_tile.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';
import 'movie_detail_screen.dart';
import '../widgets/home/home_theme.dart';


class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _openDetail(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer2<CatalogViewModel, LibraryViewModel>(
      builder: (context, catalog, library, _) {
        if (catalog.isLoading) {
          return const Scaffold(body: LoadingState(label: 'Loading...'));
        }

        final movies = library.watchlistIds
            .map(catalog.byId)
            .whereType<Movie>()
            .toList();

        return Scaffold(
          backgroundColor: HomeTheme.bgBottom,
          body: SafeArea(
              child: Column(
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Center(
                      child: Text(
                        'Watchlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: movies.isEmpty
                          ? const EmptyState(
                              icon: Icons.favorite_border,
                              title: 'No items saved',
                              message: 'Add movies to your watchlist from Home.',
                            )
                          : ListView.separated(
                              key: const PageStorageKey('watchlist_list'),
                              itemCount: movies.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, i) {
                                final m = movies[i];
                                const category = 'Action';
                                const type = 'Movie';

                                return Dismissible(
                                  key: ValueKey<int>(m.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  onDismissed: (_) =>
                                      library.removeFromWatchlist(m.id),
                                  child: WatchlistMovieTile(
                                    movie: m,
                                    category: category,
                                    type: type,
                                    onTap: () => _openDetail(context, m.id),
                                    onToggleHeart: () =>
                                        library.toggleWatchlist(m.id),
                                  ),
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
