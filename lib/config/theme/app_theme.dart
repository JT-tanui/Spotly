import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const _lightPrimary =
      Color(0xFF6F3DFF); // Light theme primary (purple)
  static const _darkPrimary =
      Color(0xFF9B79FF); // Dark theme primary (lighter purple)
  static const _accentColor = Color(0xFFFF6A3D); // Accent color (orange)
  static const _errorColor = Color(0xFFFF3B30); // Error red

  // Background colors
  static const _darkBackground = Color(0xFF121212); // Pure black for OLED
  static const _darkSurface = Color(0xFF1E1E1E); // Slightly lighter black
  static const _darkCard = Color(0xFF2C2C2E); // Card background for dark mode
  static const _lightBackground = Color(0xFFF7F8FC); // Light gray background
  static const _lightSurface = Color(0xFFFFFFFF); // White surface

  // Text sizes following Material 3 guidelines
  static const _textSmall = 12.0;
  static const _textRegular = 14.0;
  static const _textMedium = 16.0;
  static const _textLarge = 18.0;
  static const _textHeadline = 22.0;

  // Generate text themes with Google Fonts
  static TextTheme _getTextTheme({required bool isDark}) {
    final textColor = isDark ? Colors.white : Colors.black;
    final textColorLight = isDark ? Colors.white70 : Colors.black87;

    return TextTheme(
      displayLarge: GoogleFonts.sora(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displayMedium: GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displaySmall: GoogleFonts.sora(
        fontSize: _textHeadline,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: _textLarge,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: _textMedium,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: _textLarge,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: _textMedium,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.sora(
        fontSize: _textRegular,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: _textMedium,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: _textRegular,
        height: 1.5,
        color: textColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: _textSmall,
        height: 1.5,
        color: textColorLight,
      ),
    );
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _accentColor,
      error: _errorColor,
      background: _lightBackground,
      surface: _lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    // Smaller, transparent app bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.sora(
        fontSize: _textHeadline,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      toolbarHeight: 56, // Standard height
      iconTheme: const IconThemeData(
        size: 24,
        color: Colors.black,
      ),
    ),
    // Refined button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(48, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.sora(
          fontSize: _textRegular,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightPrimary,
        textStyle: GoogleFonts.sora(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        fontSize: _textRegular,
        color: Colors.grey[500],
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    iconTheme: const IconThemeData(
      size: 24,
      color: Colors.black87,
    ),
    textTheme: _getTextTheme(isDark: false),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: _lightSurface,
      indicatorColor: _lightPrimary.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        return const IconThemeData(size: 24);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200]!,
      selectedColor: _lightPrimary,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.black87,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    scaffoldBackgroundColor: _lightBackground,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _accentColor,
      error: _errorColor,
      background: _darkBackground,
      surface: _darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: _darkBackground,
    // Smaller, transparent app bar for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.sora(
        fontSize: _textHeadline,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      toolbarHeight: 56, // Standard height
      iconTheme: const IconThemeData(
        size: 24,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(48, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.sora(
          fontSize: _textRegular,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
        textStyle: GoogleFonts.sora(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: _darkCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: GoogleFonts.inter(
        color: Colors.white70,
        fontSize: _textRegular,
      ),
      hintStyle: GoogleFonts.inter(
        color: Colors.white54,
        fontSize: _textRegular,
      ),
    ),
    cardTheme: CardTheme(
      color: _darkCard,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
      size: 24,
    ),
    textTheme: _getTextTheme(isDark: true),
    dividerTheme: const DividerThemeData(
      color: Colors.white10,
      thickness: 0.5,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkSurface,
      height: 64,
      indicatorColor: _darkPrimary.withOpacity(0.15),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        return const IconThemeData(size: 24);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _darkCard,
      selectedColor: _darkPrimary,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white70,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}
