import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/home/home_theme.dart';

class SearchBarPill extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchBarPill({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: HomeTheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          const Icon(Icons.search, color: Color(0xFF9FA1B5)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFF9FA1B5)),
                border: InputBorder.none,
              ),
            ),
          ),
          if (hasText)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.clear, color: Color(0xFF9FA1B5)),
            ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
