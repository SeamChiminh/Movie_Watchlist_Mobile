import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/asset_movie_repository.dart';
import 'data/movie_repository.dart';
import 'data/prefs_storage.dart';
import 'viewmodels/catalog_viewmodel.dart';
import 'viewmodels/library_viewmodel.dart';
import 'views/shell_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(
    repository: AssetMovieRepository(),
    storage: PrefsStorage(),
  ));
}

class MyApp extends StatelessWidget {
  final MovieRepository repository;
  final PrefsStorage storage;

  const MyApp({
    super.key,
    required this.repository,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MovieRepository>.value(value: repository),
        Provider<PrefsStorage>.value(value: storage),

        ChangeNotifierProvider(
          create: (_) => LibraryViewModel(storage)..init(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CatalogViewModel(ctx.read<MovieRepository>())..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Watchlist',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const ShellView(),
      ),
    );
  }
}