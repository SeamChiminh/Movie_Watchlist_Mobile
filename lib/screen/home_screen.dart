import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/library_viewmodel.dart';
import '../viewmodels/user_profile_viewmodel.dart';
import '../widgets/loading_state.dart';
import '../widgets/error_state.dart';
import 'movie_detail_screen.dart';
import 'most_popular_screen.dart';
import 'category_screen.dart';

// Home UI parts
import '../widgets/home/home_header.dart';
import '../widgets/home/featured_carousel.dart';
import '../widgets/home/category_row.dart';
import '../widgets/home/popular_section.dart';
import '../widgets/home/home_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scrollKey = const PageStorageKey('home_scroll');
  int _selectedCategory = 0;

  void _openDetail(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer3<CatalogViewModel, LibraryViewModel, UserProfileViewModel>(
      builder: (context, catalog, library, userProfile, _) {
        final userName = userProfile.name;
        final firstName = userName.split(' ').first;
        return Scaffold(
          backgroundColor: HomeTheme.bgBottom,
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Builder(
                  builder: (_) {
                    if (catalog.isLoading) {
                      return const LoadingState(label: 'Loading movies...');
                    }
                    if (catalog.error != null) {
                      return ErrorState(
                        message: catalog.error!,
                        onRetry: catalog.load,
                      );
                    }

                    final heroMovies = catalog.popularMovies.take(3).toList();

                    final popularMovies = [...catalog.allMovies]
                      ..sort((a, b) => b.rating.compareTo(a.rating));

                    return ListView(
                      key: _scrollKey,
                      children: [
                        HomeHeader(
                          name: firstName,
                          fullName: userName,
                          subtitle: "Let's stream your favorite movie",
                          profileImagePath: userProfile.profileImagePath,
                        ),
                        const SizedBox(height: 18),
                        FeaturedCarousel(
                          movies: heroMovies,
                          onTapMovie: (id) => _openDetail(context, id),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CategoryRow(
                          items: const [
                            'All',
                            'Action',
                            'Animation',
                            'Comedy',
                            'Crime',
                            'Drama',
                            'Horror',
                            'Mystery',
                            'Science Fiction',
                            'Thriller',
                          ],
                          selectedIndex: _selectedCategory,
                          onChanged: (i) =>
                              setState(() => _selectedCategory = i),
                          movies: catalog.allMovies,
                          onTapMovie: (id) => _openDetail(context, id),
                          onSeeAll: () {
                            final categoryName = _selectedCategory == 0
                                ? 'All'
                                : const [
                                    'All',
                                    'Action',
                                    'Animation',
                                    'Comedy',
                                    'Crime',
                                    'Drama',
                                    'Horror',
                                    'Mystery',
                                    'Science Fiction',
                                    'Thriller',
                                  ][_selectedCategory];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(categoryName: categoryName),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 26),
                        PopularSection(
                          title: 'Most popular',
                          actionText: 'See All',
                          onAction: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const MostPopularScreen()),
                            );
                          },
                          movies: popularMovies.take(3).toList(),
                          isSaved: (id) => library.isInWatchlist(id),
                          isWatched: (id) => library.isWatched(id),
                          onTapMovie: (id) => _openDetail(context, id),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
            ),
        );
      },
    );
  }
}
