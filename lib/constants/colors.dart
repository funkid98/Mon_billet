import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color primaryYellow = Color(0xFFFFC107);
  static const Color primaryPurpleDark = Color.fromARGB(255, 35, 16, 143);
  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color amber = Color(0xFFFFC107);
  static const Color green = Color(0xFF4CAF50);

  // Neutral Colors
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyLighter = Color(0xFFE3F2FD);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // Gradient Colors
  static const List<Color> blueGradient = [
    primaryBlue,
    primaryBlueDark,
  ];
}
