import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/search/search_bar_pill.dart';
import 'package:movie_watchlist_mobile/widgets/search/search_movie_result_tile.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/empty_state.dart';
import 'movie_detail_screen.dart';
import '../widgets/home/home_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scrollKey = const PageStorageKey('search_scroll');
  final _controller = TextEditingController();

  void _openDetail(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: id)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer2<CatalogViewModel, LibraryViewModel>(
      builder: (context, catalog, library, _) {
        // keep textfield in sync with VM
        if (_controller.text != catalog.query) {
          _controller.value = _controller.value.copyWith(
            text: catalog.query,
            selection: TextSelection.collapsed(offset: catalog.query.length),
          );
        }

        final results = catalog.searchResults;

        return Scaffold(
          backgroundColor: HomeTheme.bgBottom,
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(
                  children: [
                    // Top search bar
                    SearchBarPill(
                      controller: _controller,
                      hintText: 'Type title',
                      onChanged: (v) => catalog.setQuery(v),
                      onClear: catalog.clearQuery,
                    ),
                    const SizedBox(height: 18),

                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (catalog.query.trim().isEmpty) {
                            return const EmptyState(
                              icon: Icons.search,
                              title: 'Search movies',
                              message: 'Type something to start searching.',
                            );
                          }

                          if (results.isEmpty) {
                            return EmptyState(
                              icon: Icons.search_off,
                              title: 'No results',
                              message: 'Try another keyword.',
                              ctaLabel: 'Clear search',
                              onCtaPressed: catalog.clearQuery,
                            );
                          }

                          return ListView.separated(
                            key: _scrollKey,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
                            itemBuilder: (context, i) {
                              final m = results[i];
                              return SearchMovieResultTile(
                                movie: m,
                                isSaved: library.isInWatchlist(m.id),
                                durationMinutes: m.duration,
                                genre: m.category,
                                type: 'Movie',
                                onTap: () => _openDetail(context, m.id),
                                onToggleHeart: () => library.toggleWatchlist(m.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
