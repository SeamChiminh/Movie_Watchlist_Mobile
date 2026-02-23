import 'package:flutter/material.dart';
import 'home/home_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const barBg = Color(0xFF2A2F3F);
    const activePill = Color(0xFF1B1F2D);
    const inactiveIcon = Color(0xFF8D93A6);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.zero,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: barBg,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
          children: [
            Expanded(
              child: _NavItem(
                index: 0,
                currentIndex: currentIndex,
                onTap: onChanged,
                icon: Icons.home_rounded,
                label: 'Home',
                activePillColor: activePill,
                inactiveColor: inactiveIcon,
              ),
            ),
            Expanded(
              child: _NavItem(
                index: 1,
                currentIndex: currentIndex,
                onTap: onChanged,
                icon: Icons.search_rounded,
                label: 'Search',
                activePillColor: activePill,
                inactiveColor: inactiveIcon,
              ),
            ),
            Expanded(
              child: _NavItem(
                index: 2,
                currentIndex: currentIndex,
                onTap: onChanged,
                icon: Icons.favorite_rounded,
                label: 'Watchlist',
                activePillColor: activePill,
                inactiveColor: inactiveIcon,
              ),
            ),
            Expanded(
              child: _NavItem(
                index: 3,
                currentIndex: currentIndex,
                onTap: onChanged,
                icon: Icons.person_rounded,
                label: 'Profile',
                activePillColor: activePill,
                inactiveColor: inactiveIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final IconData icon;
  final String label;

  final Color activePillColor;
  final Color inactiveColor;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.activePillColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pillW = constraints.maxWidth * 0.88;
          const pillH = 44.0;

          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                width: selected ? pillW : 0,
                height: selected ? pillH : 0,
                decoration: BoxDecoration(
                  color: activePillColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.98, end: 1.0).animate(anim),
                    child: child,
                  ),
                ),
                child: selected
                    ? Column(
                        key: const ValueKey('selected'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: HomeTheme.accent, size: 24),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: HomeTheme.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        icon,
                        key: const ValueKey('unselected'),
                        color: inactiveColor,
                        size: 24,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
