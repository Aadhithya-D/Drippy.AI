import 'package:flutter/material.dart';

class AppTheme{
  static Color backgroundColor = const Color(0xFF222831);
  static Color primaryColor = const Color(0xFF393E46);
  static Color secondaryColor = const Color(0xFF00ADB5);
  static Color contrastColor = const Color(0xFFEEEEEE);

  static ThemeData darkThemeData = ThemeData(
      colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    background: Color(0xFF222831),
    primary: Color(0xFF393E46),
    secondary: Color(0xFF00ADB5),
    tertiary: Color(0xFFEEEEEE),
    error: Colors.red,
    onError: Colors.red,
    onBackground: Color(0xFF222831),
    surface: Color(0xFF393E46),
    onSurface: Color(0xFF393E46),
    onPrimary: Colors.grey,
    onSecondary: Color(0xFF00ADB5),
  ));

  static ThemeData lightThemeData = ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        background: Colors.white,
        primary: Color(0xFFE8E8EE),
        secondary: Color(0xFFF4F5FA),
        tertiary: Colors.black,
        error: Colors.red,
        onError: Colors.red,
        onBackground: Color(0xFFE3FDFD),
        surface: Color(0xFF393E46),
        onSurface: Color(0xFF393E46),
        onPrimary: Colors.grey,
        onSecondary: Color(0xFFA6E3E9),
      ));
}
