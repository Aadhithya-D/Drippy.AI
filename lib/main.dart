import 'package:fashion_ai/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'firebase_options.dart';

// Define a constant for the SharedPreferences key
const String themeModeKey = "themeMode";

// Function to get the theme mode preference from SharedPreferences
Future<bool> getThemeModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(themeModeKey) ?? false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final isDark = await getThemeModePreference();

  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drippy.AI',
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
