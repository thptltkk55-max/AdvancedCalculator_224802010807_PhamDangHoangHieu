import 'package:flutter/material.dart';

import 'calculator_mode.dart';

class CalculatorSettings {
  const CalculatorSettings({
    this.themeMode = ThemeMode.system,
    this.decimalPrecision = 6,
    this.angleMode = AngleMode.degrees,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
  });

  final ThemeMode themeMode;
  final int decimalPrecision;
  final AngleMode angleMode;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;

  CalculatorSettings copyWith({
    ThemeMode? themeMode,
    int? decimalPrecision,
    AngleMode? angleMode,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  }) {
    return CalculatorSettings(
      themeMode: themeMode ?? this.themeMode,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      angleMode: angleMode ?? this.angleMode,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      historySize: historySize ?? this.historySize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'decimalPrecision': decimalPrecision,
      'angleMode': angleMode.name,
      'hapticFeedback': hapticFeedback,
      'soundEffects': soundEffects,
      'historySize': historySize,
    };
  }

  factory CalculatorSettings.fromJson(Map<String, dynamic> json) {
    return CalculatorSettings(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      decimalPrecision: json['decimalPrecision'] as int? ?? 6,
      angleMode: AngleMode.values.firstWhere(
        (mode) => mode.name == json['angleMode'],
        orElse: () => AngleMode.degrees,
      ),
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      soundEffects: json['soundEffects'] as bool? ?? false,
      historySize: json['historySize'] as int? ?? 50,
    );
  }
}
