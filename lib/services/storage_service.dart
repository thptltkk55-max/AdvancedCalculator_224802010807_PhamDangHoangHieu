import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calculation_history.dart';
import '../models/calculator_settings.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getStringList(AppConstants.historyKey) ?? [];
    return rawItems
        .map((item) {
          try {
            return CalculationHistory.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<CalculationHistory>()
        .toList();
  }

  static Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = history.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(AppConstants.historyKey, rawItems);
  }

  static Future<CalculatorSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.settingsKey);
    if (raw == null) {
      return const CalculatorSettings();
    }
    try {
      return CalculatorSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const CalculatorSettings();
    }
  }

  static Future<void> saveSettings(CalculatorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.settingsKey, jsonEncode(settings.toJson()));
  }

  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.themeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, mode.name);
  }
}
