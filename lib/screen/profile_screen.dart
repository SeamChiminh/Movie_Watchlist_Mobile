import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/home/home_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'about_us_screen.dart';
import 'legal_and_policies_screen.dart';
import 'help_and_feedback_screen.dart';
import '../viewmodels/library_viewmodel.dart';
import '../data/prefs_storage.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // mock user data
  String _name = 'Seam Chiminh';
  String _email = 'seamchiminh@gmail.com';
  String _phone = '012 345 678';
  final String _joinDate = 'January 2026';
  String? _profileImagePath;

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: HomeTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Color(0xFFB9B9C5), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final storage = PrefsStorage();
              await storage.setLoggedIn(false);
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: HomeTheme.accent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final library = context.watch<LibraryViewModel>();
    
    // Get actual counts from LibraryViewModel
    final moviesWatched = library.watched.length;
    final watchlistCount = library.watchlistIds.length;

    return Scaffold(
      backgroundColor: HomeTheme.bgBottom,
      body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // screen scrollable if content is taller than screen
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Profile card
                        _Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: HomeTheme.accent.withOpacity(0.2),
                                    backgroundImage: _profileImagePath != null
                                        ? FileImage(File(_profileImagePath!))
                                        : null,
                                    child: _profileImagePath == null
                                        ? Text(
                                            _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                                            style: const TextStyle(
                                              color: HomeTheme.accent,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              size: 12,
                                              color: Colors.white.withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Join since $_joinDate',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.5),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  _IconPillButton(
                                    icon: Icons.edit_rounded,
                                    onTap: () async {
                                      final result = await Navigator.of(context)
                                          .push<(String, String, String, String?)>(
                                        MaterialPageRoute(
                                          builder: (_) => EditProfileScreen(
                                            initialName: _name,
                                            initialEmail: _email,
                                            initialPhone: _phone,
                                          ),
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          _name = result.$1;
                                          _email = result.$2;
                                          _phone = result.$3;
                                          _profileImagePath = result.$4;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatItem(
                                      icon: Icons.local_movies_rounded,
                                      label: 'Watched',
                                      value: '$moviesWatched',
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  Expanded(
                                    child: _StatItem(
                                      icon: Icons.bookmark_rounded,
                                      label: 'Watchlist',
                                      value: '$watchlistCount',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Personal Information section
                        _SectionCard(
                          title: 'Personal Information',
                          children: [
                            _InfoRow(
                              icon: Icons.person_rounded,
                              label: 'Full Name',
                              value: _name,
                            ),
                            _Divider(),
                            _InfoRow(
                              icon: Icons.email_rounded,
                              label: 'Email',
                              value: _email,
                            ),
                            _Divider(),
                            _InfoRow(
                              icon: Icons.phone_rounded,
                              label: 'Phone',
                              value: _phone,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Account section
                        _SectionCard(
                          title: 'Account',
                          children: [
                            _SettingRow(
                              icon: Icons.lock_rounded,
                              label: 'Change Password',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ChangePasswordScreen()),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // More section
                        _SectionCard(
                          title: 'More',
                          children: [
                            _SettingRow(
                              icon: Icons.shield_rounded,
                              label: 'Legal and Policies',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LegalAndPoliciesScreen(),
                                  ),
                                );
                              },
                            ),
                            _Divider(),
                            _SettingRow(
                              icon: Icons.help_rounded,
                              label: 'Help & Feedback',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const HelpAndFeedbackScreen(),
                                  ),
                                );
                              },
                            ),
                            _Divider(),
                            _SettingRow(
                              icon: Icons.info_rounded,
                              label: 'About Us',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AboutUsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const Spacer(),

                        const SizedBox(height: 18),

                        // Logout button
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HomeTheme.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            onPressed: () => _showLogoutConfirmDialog(context),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
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


class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomeTheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, color: const Color(0xFFB9B9C5)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: HomeTheme.accent,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconPillButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HomeTheme.accent.withOpacity(0.25)),
        ),
        child: Icon(icon, color: HomeTheme.accent, size: 22),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.white.withOpacity(0.06),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: HomeTheme.accent,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: const Color(0xFFB9B9C5), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
