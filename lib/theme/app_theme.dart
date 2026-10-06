import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF070B14);
  static const Color backgroundDeep = Color(0xFF050810);
  static const Color surface = Color(0xFF121827);
  static const Color surfaceElevated = Color(0xFF1A2235);
  static const Color border = Color(0xFF2D3A52);

  static const Color primary = Color(0xFF7C6CFF);
  static const Color secondary = Color(0xFF22D3EE);
  static const Color tertiary = Color(0xFFFF6B9D);
  static const Color accent = primary;

  static const Color textPrimary = Color(0xFFF8FAFF);
  static const Color textSecondary = Color(0xFFB4BED0);
  static const Color textMuted = Color(0xFF7A869C);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2235), Color(0xFF121827)],
  );

  static const LinearGradient heroGlow = LinearGradient(
    colors: [
      Color(0x337C6CFF),
      Color(0x0022D3EE),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 58,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: textPrimary,
        height: 1.05,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: textPrimary,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.4,
      );

  static TextStyle get cardTitle => GoogleFonts.poppins(
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
        letterSpacing: 0.3,
      );

  static BoxDecoration cardDecoration({
    bool highlighted = false,
    Color? glowColor,
  }) {
    final glow = glowColor ?? primary;
    return BoxDecoration(
      gradient: surfaceGradient,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: highlighted ? glow.withValues(alpha: 0.55) : border,
        width: highlighted ? 1.5 : 1,
      ),
      boxShadow: highlighted
          ? [
              BoxShadow(
                color: glow.withValues(alpha: 0.18),
                blurRadius: 28,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }
}
