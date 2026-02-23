import 'package:flutter/material.dart';
import '../widgets/home/home_theme.dart';
import '../widgets/auth/auth_text_field.dart';
import '../data/prefs_storage.dart';
import 'shell_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    // Static credentials
    const validEmail = 'seamchiminh@gmail.com';
    const validPassword = '12345678';

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (email != validEmail || pass != validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Login success - save login state and navigate to app
    final storage = PrefsStorage();
    try {
      await storage.setLoggedIn(true);
      
      // On web, add a small delay to ensure localStorage is committed
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Verify the save completed (especially important for web)
      final verified = await storage.isLoggedIn();
      if (!verified) {
        throw Exception('Login state verification failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save login state: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful! Welcome $email'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ShellView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeTheme.bgBottom,
      body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 90),
                        const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Welcome back! Please enter\nyour details.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB9B9C5),
                            fontSize: 14,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 60),
                        const _Label('Email Address'),
                        const SizedBox(height: 10),
                        AuthTextField(
                          controller: _emailCtrl,
                          hintText: 'Enter Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 22),
                        const _Label('Password'),
                        const SizedBox(height: 10),
                        AuthTextField(
                          controller: _passCtrl,
                          hintText: 'Enter Password',
                          obscureText: _obscure,
                          suffix: InkWell(
                            onTap: () => setState(() => _obscure = !_obscure),
                            borderRadius: BorderRadius.circular(999),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                _obscure
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: const Color(0xFFB9B9C5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Forgot password (mock)')),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: HomeTheme.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Spacer(),
                        SizedBox(
                          height: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HomeTheme.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            onPressed: _login,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
