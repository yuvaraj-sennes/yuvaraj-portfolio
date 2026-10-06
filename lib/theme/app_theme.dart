import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0C0F14);
  static const Color surface = Color(0xFF151A22);
  static const Color surfaceElevated = Color(0xFF1C2330);
  static const Color border = Color(0xFF2A3344);
  static const Color accent = Color(0xFF5B9FD4);
  static const Color accentMuted = Color(0xFF3D6F99);
  static const Color textPrimary = Color(0xFFF4F6FA);
  static const Color textSecondary = Color(0xFF9AA5B5);
  static const Color textMuted = Color(0xFF6B7789);

  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 20;

  static const EdgeInsets sectionPaddingDesktop =
      EdgeInsets.symmetric(horizontal: 72, vertical: 88);
  static const EdgeInsets sectionPaddingMobile =
      EdgeInsets.symmetric(horizontal: 24, vertical: 64);

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
        color: textPrimary,
        height: 1.05,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: textPrimary,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.65,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textMuted,
        letterSpacing: 0.2,
      );

  static BoxDecoration cardDecoration({bool highlighted = false}) {
    return BoxDecoration(
      color: highlighted ? surfaceElevated : surface,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: highlighted ? accent.withValues(alpha: 0.35) : border,
      ),
    );
  }
}
