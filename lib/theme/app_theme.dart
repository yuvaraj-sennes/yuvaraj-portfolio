import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D9FF);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color darkBg = Color(0xFF0A0E21);
  static const Color darkCard = Color(0xFF1D1E33);
  static const Color lightText = Color(0xFFFFFFFF);
  static const Color greyText = Color(0xFF8D8E98);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF0A0E21),
      Color(0xFF1A1F3C),
      Color(0xFF0A0E21),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text Styles
  static TextStyle get headingStyle => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: lightText,
      );

  static TextStyle get subHeadingStyle => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: lightText,
      );

  static TextStyle get titleStyle => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: lightText,
      );

  static TextStyle get bodyStyle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: greyText,
        height: 1.6,
      );

  static TextStyle get buttonStyle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: lightText,
      );

  // Box Decorations
  static BoxDecoration get glassCard => BoxDecoration(
        color: darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration get gradientBorder => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: primaryGradient,
      );
}
