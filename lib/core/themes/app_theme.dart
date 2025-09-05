import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.indigo,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // Fixed elevated button style with MaterialStateProperty
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade400;
            }
            return primaryColor;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white70;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          elevation: MaterialStateProperty.all(2),
        ),
      ),
      // Add TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      // Add OutlinedButton theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return primaryColor;
          }),
          side: MaterialStateProperty.resolveWith<BorderSide>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: Colors.grey.shade300);
            }
            return BorderSide(color: primaryColor);
          }),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
