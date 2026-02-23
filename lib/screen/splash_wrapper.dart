import 'package:flutter/material.dart';
import '../data/prefs_storage.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'shell_view.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted || _navigated) return;
    _navigated = true;

    // Ensure SharedPreferences is ready before checking login state
    final storage = PrefsStorage();
    bool isLoggedIn = false;
    
    // Retry up to 5 times to ensure SharedPreferences is ready (especially on web)
    for (int i = 0; i < 5; i++) {
      try {
        isLoggedIn = await storage.isLoggedIn();
        if (isLoggedIn) break; // If logged in, no need to retry
        if (i < 4) await Future.delayed(const Duration(milliseconds: 150));
      } catch (e) {
        print('Error checking login state (attempt ${i + 1}): $e');
        if (i < 4) await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const ShellView() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
