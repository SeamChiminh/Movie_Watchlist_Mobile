import 'package:flutter/material.dart';
import '../widgets/home/home_theme.dart';

class LegalAndPoliciesScreen extends StatelessWidget {
  const LegalAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeTheme.bgBottom,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: HomeTheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Legal and Policies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PolicySection(
                      title: 'Privacy Policy',
                      content:
                          'Movie Watchlist stores your data locally on your device. We do not collect, transmit, or share your personal information, watchlist, or viewing history with third parties. Profile data and preferences are stored only on your device and can be cleared by uninstalling the app.',
                    ),
                    SizedBox(height: 20),
                    _PolicySection(
                      title: 'Terms of Use',
                      content:
                          'By using Movie Watchlist, you agree to use the app for personal, non-commercial purposes. The movie information and artwork displayed are for reference only. Do not use the app to distribute copyrighted content. We reserve the right to update these terms; continued use of the app constitutes acceptance of changes.',
                    ),
                    SizedBox(height: 20),
                    _PolicySection(
                      title: 'Data Storage',
                      content:
                          'Your watchlist, watched history, and profile details are saved locally using your device storage. No account or server sync is required. If you clear app data or uninstall, this information will be removed.',
                    ),
                    SizedBox(height: 20),
                    _PolicySection(
                      title: 'Contact',
                      content:
                          'For questions about our legal and policies, please contact us through the Help & Feedback section in the app or via the support email provided in the app listing.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HomeTheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: HomeTheme.accent, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
