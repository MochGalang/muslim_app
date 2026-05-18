import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF064E3B);
  static const Color secondary = Color(0xFFD4AF37);
  
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1C1C);
  
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFF9F9F9);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surfaceLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primary),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: primary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
        displayMedium: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.w600, color: textDark),
        titleLarge: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge: GoogleFonts.inter(fontSize: 18, color: textDark),
        bodyMedium: GoogleFonts.inter(fontSize: 16, color: textDark.withOpacity(0.8)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      cardTheme: CardTheme(
        color: surfaceLight,
        elevation: 4,
        shadowColor: primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: secondary),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: secondary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold, color: textLight),
        displayMedium: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.w600, color: textLight),
        titleLarge: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: textLight),
        bodyLarge: GoogleFonts.inter(fontSize: 18, color: textLight),
        bodyMedium: GoogleFonts.inter(fontSize: 16, color: textLight.withOpacity(0.8)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: secondary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      useMaterial3: true,
    );
  }
}
