import 'dart:io';
import 'package:flutter/material.dart';
import 'home_theme.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String fullName;
  final String subtitle;
  final String? profileImagePath;

  const HomeHeader({
    super.key,
    required this.name,
    required this.fullName,
    required this.subtitle,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: HomeTheme.accent.withOpacity(0.2),
          backgroundImage: profileImagePath != null
              ? FileImage(File(profileImagePath!))
              : null,
          child: profileImagePath == null
              ? Text(
                  fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: HomeTheme.accent,
                    fontSize: 20,
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
                'Hello, $name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: HomeTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
