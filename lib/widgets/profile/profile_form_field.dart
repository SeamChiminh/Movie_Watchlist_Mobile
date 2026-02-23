import 'package:flutter/material.dart';
import 'package:movie_watchlist_mobile/widgets/home/home_theme.dart';


class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const ProfileFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: HomeTheme.surface.withOpacity(0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.white,
           fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB9B9C5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
