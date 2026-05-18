import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.lightAccent,
          brightness: Brightness.light,
          primary: AppConstants.lightPrimary,
          secondary: AppConstants.lightSecondary,
          tertiary: AppConstants.lightAccent,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.darkPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.darkAccent,
          brightness: Brightness.dark,
          primary: AppConstants.darkAccent,
          secondary: AppConstants.darkSecondary,
          tertiary: AppConstants.darkAccent,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false),
      );

  Future<void> loadThemeMode() async {
    _themeMode = await StorageService.loadThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await StorageService.saveThemeMode(mode);
  }
}
