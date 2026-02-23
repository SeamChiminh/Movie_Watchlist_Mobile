import 'package:flutter/material.dart';
import '../widgets/home/home_theme.dart';

class HelpAndFeedbackScreen extends StatelessWidget {
  const HelpAndFeedbackScreen({super.key});

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
                    'Help & Feedback',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HelpSection(
                      icon: Icons.favorite_rounded,
                      title: 'Adding to your watchlist',
                      content:
                          'Tap the heart icon on any movie—on the home screen, search results, category list, or movie detail. The heart turns red when the movie is saved. Open the Watchlist tab to see all saved movies.',
                    ),
                    const SizedBox(height: 20),
                    const _HelpSection(
                      icon: Icons.play_circle_rounded,
                      title: 'Marking movies as watched',
                      content:
                          'Open a movie\'s detail screen and tap the Play button. It will change to "Already Watched" (green) and your watched count will update on your Profile. This cannot be undone.',
                    ),
                    const SizedBox(height: 20),
                    const _HelpSection(
                      icon: Icons.search_rounded,
                      title: 'Searching for movies',
                      content:
                          'Go to the Search tab and type part of a movie title. Results update as you type. Tap a result to open the movie detail or use the heart to add it to your watchlist.',
                    ),
                    const SizedBox(height: 20),
                    const _HelpSection(
                      icon: Icons.swipe_rounded,
                      title: 'Removing from watchlist',
                      content:
                          'On the Watchlist screen, swipe a movie card to the left to remove it. You can also tap the heart icon on the card or on the movie detail to remove it from the watchlist.',
                    ),
                    const SizedBox(height: 24),
                    _FeedbackCard(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Send your feedback to: support@moviewatchlist.app',
                            ),
                            backgroundColor: HomeTheme.surface,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
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

class _HelpSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _HelpSection({
    required this.icon,
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
              Icon(icon, color: HomeTheme.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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

class _FeedbackCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FeedbackCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: HomeTheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: HomeTheme.accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: HomeTheme.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.feedback_rounded,
                color: HomeTheme.accent,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to see support email',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
