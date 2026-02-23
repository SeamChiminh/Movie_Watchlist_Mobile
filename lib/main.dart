import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/asset_movie_repository.dart';
import 'data/movie_repository.dart';
import 'data/prefs_storage.dart';
import 'viewmodels/catalog_viewmodel.dart';
import 'viewmodels/library_viewmodel.dart';
import 'viewmodels/user_profile_viewmodel.dart';
import 'screen/splash_wrapper.dart';
import 'theme/app_colors.dart';

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
        ChangeNotifierProvider(
          create: (_) => UserProfileViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Watchlist',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashWrapper(),
      ),
    );
  }
}


final lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: AppColors.textWhite, // Consistent background
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.blueAccent,
    onPrimary: AppColors.textWhite,
    secondary: AppColors.green,
    onSecondary: AppColors.textWhite,
    surface: AppColors.textWhite,
    onSurface: AppColors.textBlack,
    error: AppColors.red,
    onError: AppColors.textWhite,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: AppColors.bgBottom, // Consistent background
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.blueAccent,
    onPrimary: AppColors.bgTop,
    secondary: AppColors.green,
    onSecondary: AppColors.bgTop,
    surface: AppColors.surface, // Use consistent surface color
    onSurface: AppColors.textWhite,
    error: AppColors.red,
    onError: AppColors.textWhite,
  ),
);