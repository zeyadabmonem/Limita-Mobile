import 'package:flutter/material.dart';

/// Centralized color palette for the app.
/// Keep every raw color value here — features should never hardcode colors.
abstract class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF3629B7);
  static const Color primaryDark = Color(0xFF241C8A);
  static const Color primaryLight = Color(0xFF6C61D6);

  static const Color secondary = Color(0xFF00C2A8);

  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6E7191);
  static const Color textDisabled = Color(0xFFB4B4C6);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE74C3C);

  static const Color border = Color(0xFFE3E3EE);
  static const Color divider = Color(0xFFECECF4);

  static const Color overlay = Color(0x99000000);
}
