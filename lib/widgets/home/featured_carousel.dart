import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../models/movie.dart';
import 'home_theme.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<Movie> movies;
  final ValueChanged<int> onTapMovie;

  final bool autoPlay;
  final Duration autoPlayInterval;

  const FeaturedCarousel({
    super.key,
    required this.movies,
    required this.onTapMovie,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _controller;

  late int _page; 
  int _index = 0;

  Timer? _timer;
  bool _isUserInteracting = false;


  int get _initialPage => widget.movies.isEmpty ? 0 : widget.movies.length * 1000;

  @override
  void initState() {
    super.initState();
    _page = _initialPage;
    _controller = PageController(viewportFraction: 0.88, initialPage: _page);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncIndex();
      _startAuto();
    });
  }

  @override
  void didUpdateWidget(covariant FeaturedCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.movies.length != widget.movies.length) {
      _syncIndex();
      _restartAuto();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _syncIndex() {
    if (widget.movies.isEmpty) return;
    setState(() => _index = _page % widget.movies.length);
  }

  void _startAuto() {
    _timer?.cancel();
    if (!widget.autoPlay) return;
    if (widget.movies.length <= 1) return;

    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      if (_isUserInteracting) return;

      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _restartAuto() {
    _timer?.cancel();
    _startAuto();
  }

  void _pauseAuto() {
    _isUserInteracting = true;
  }

  void _resumeAuto() {
    _isUserInteracting = false;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!mounted) return;

    final dy = event.scrollDelta.dy;
    if (dy == 0) return;

    _pauseAuto();

    final target = dy > 0 ? _page + 1 : _page - 1;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _resumeAuto();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Listener(
            onPointerSignal: _handlePointerSignal,
            onPointerDown: (_) => _pauseAuto(),
            onPointerUp: (_) => _resumeAuto(),
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: const {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (p) {
                  _page = p;
                  if (!mounted) return;
                  setState(() => _index = p % widget.movies.length);
                },
                itemBuilder: (context, i) {
                  final m = widget.movies[i % widget.movies.length];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _FeaturedCard(
                      title: m.title,
                      posterAsset: m.posterAsset,
                      onTap: () => widget.onTapMovie(m.id),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _DotsIndicator(count: widget.movies.length, index: _index),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String posterAsset;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.title,
    required this.posterAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              posterAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: HomeTheme.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.white54),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 110,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;

  const _DotsIndicator({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: active ? 34 : 10,
          decoration: BoxDecoration(
            color: active ? HomeTheme.accent : HomeTheme.surface,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
