import 'package:flutter/material.dart';
import '../utils/constants.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor, // Flag Green
  scaffoldBackgroundColor: backgroundColor, // Off-white
  fontFamily: 'JameelNoori',
  brightness: Brightness.light,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: textPrimary), // +2px for Urdu
    bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      elevation: 3,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: primaryColor,
  // Let the system handle scaffold background in dark mode for proper dark mode
  scaffoldBackgroundColor: Colors.grey[900], // soft dark background
  fontFamily: 'JameelNoori',
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      elevation: 3,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    fillColor: Colors.grey[800],
    filled: true,
  ),
);
