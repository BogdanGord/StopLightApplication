import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const blue = Color(0xFF0D47A1);
  const bg = Color(0xFFF7FAFF);
  const card = Colors.white;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      primary: blue,
      secondary: const Color(0xFF1565C0),
      surface: card,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 24,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFFE3E8F1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFFE3E8F1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
  );
}
