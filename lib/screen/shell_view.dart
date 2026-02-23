import 'package:flutter/material.dart';
import '../data/prefs_storage.dart';
import '../widgets/app_bottom_nav.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  int index = 0;
  bool _checkingAuth = true;

  final _pages = const [
    HomeScreen(key: PageStorageKey('home')),
    SearchScreen(key: PageStorageKey('search')),
    WatchlistScreen(key: PageStorageKey('watchlist')),
    ProfileScreen(key: PageStorageKey('profile')),
  ];

  @override
  void initState() {
    super.initState();
    _verifyLoginState();
  }

  Future<void> _verifyLoginState() async {
    final storage = PrefsStorage();
    final isLoggedIn = await storage.isLoggedIn();
    
    if (!mounted) return;
    
    if (!isLoggedIn) {
      // User is not logged in, redirect to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    
    setState(() {
      _checkingAuth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        child: Container(
          color: Colors.transparent,
          child: AppBottomNav(
            currentIndex: index,
            onChanged: (i) => setState(() => index = i),
          ),
        ),
      ),
    );
  }
}
