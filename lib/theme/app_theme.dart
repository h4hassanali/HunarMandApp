import 'package:flutter/material.dart';

// Professional Marketplace Colors
const Color primaryColor = Color(0xFF10B981); // Emerald Green (Growth, Success)
const Color primaryDark = Color(0xFF059669);
const Color accentColor = Color(0xFFF59E0B); // Amber (Highlights, Ratings)
const Color surfaceColor = Color(0xFFFFFFFF);
const Color backgroundColor = Color(0xFFF9FAFB); // Very light grey
const Color textPrimary = Color(0xFF1F2937); // Dark Blue-Grey
const Color textSecondary = Color(0xFF6B7280); // Medium Grey
const Color errorColor = Color(0xFFEF4444);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  fontFamily: 'JameelNoori', // Works for both English (as fallback) and Urdu
  brightness: Brightness.light,
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: accentColor,
    surface: surfaceColor,
    background: backgroundColor,
    error: errorColor,
  ),

  textTheme: const TextTheme(
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
    bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
    bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
    bodySmall: TextStyle(fontSize: 12, color: textSecondary),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: surfaceColor,
    foregroundColor: textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'JameelNoori',
    ),
    iconTheme: IconThemeData(color: textPrimary),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 2,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'JameelNoori'),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: textSecondary),
    hintStyle: TextStyle(color: Colors.grey.shade400),
  ),

  // cardTheme: CardTheme(
  //   color: surfaceColor,
  //   elevation: 1,
  //   shadowColor: Colors.black.withOpacity(0.05),
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //   margin: const EdgeInsets.all(0),
  // ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: const Color(0xFF111827), // Dark Blue-Grey
  fontFamily: 'JameelNoori',
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    primary: primaryColor,
    secondary: accentColor,
    surface: const Color(0xFF1F2937),
    background: const Color(0xFF111827),
  ),

  textTheme: const TextTheme(
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE5E7EB)),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
    bodySmall: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F2937),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
       color: Colors.white,
       fontSize: 20,
       fontWeight: FontWeight.bold,
       fontFamily: 'JameelNoori'
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF374151),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'JameelNoori'),
    ),
  ),
);
