import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------- Background Colors (Consistent across app) ----------
  static const bgTop = Color(0xFF1B1A2A);
  static const bgBottom = Color(0xFF0B0B12);
  static const surface = Color(0xFF2A2B3E);

  // ---------- Primary ----------
  static const primaryDark = Color(0xFF1B1A2A); // Same as bgTop for consistency
  static const primarySoft = Color(0xFF2A2B3E); // Same as surface for consistency
  static const blueAccent = Color(0xFF12CDD9);
  static const accent = Color(0xFF19D3C5); // Teal accent used in HomeTheme

  // ---------- Secondary ----------
  static const green = Color(0xFF22B07D);
  static const orange = Color(0xFFFF8700);
  static const red = Color(0xFFFB4141);

  // ---------- Text / Neutral ----------
  static const textBlack = Color(0xFF171725);
  static const textDarkGrey = Color(0xFF696974);
  static const textGrey = Color(0xFF92929D);
  static const textWhiteGrey = Color(0xFFEBEBEF);
  static const textWhite = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFFB9B9C5); // Muted text color
  static const lineDark = Color(0xFFEAEAEA);
}
