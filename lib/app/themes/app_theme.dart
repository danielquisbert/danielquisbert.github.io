import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData macosDarkTheme =
      ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: const Color(0xFF0A84FF),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFF0A84FF)),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    cardTheme: CardTheme(
      color: Colors.black.withOpacity(0.7),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static const Color accentColor = Color(0xFF0A84FF);
}
