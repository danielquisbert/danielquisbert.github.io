import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData macosTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF007AFF), // macOS blue
    scaffoldBackgroundColor: Color(0xFFF5F5F7), // Light background
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF007AFF)),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: IconThemeData(color: Color(0xFF007AFF)),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static const Color sidebarColor = Color(0xFFD8D8D8);
  static const Color accentColor = Color(0xFF007AFF);
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5F5F7), Color(0xFFE4E4E6)],
  );
}