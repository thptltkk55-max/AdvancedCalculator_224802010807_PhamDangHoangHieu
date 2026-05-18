import 'package:flutter/material.dart';

class AppConstants {
  static const historyKey = 'calculation_history';
  static const settingsKey = 'calculator_settings';
  static const themeKey = 'calculator_theme_mode';
  static const defaultHistorySize = 50;

  static const lightPrimary = Color(0xFF1E1E1E);
  static const lightSecondary = Color(0xFF424242);
  static const lightAccent = Color(0xFFFF6B6B);

  static const darkPrimary = Color(0xFF121212);
  static const darkSecondary = Color(0xFF2C2C2C);
  static const darkAccent = Color(0xFF4ECDC4);
}

class CalculatorButtons {
  static const basic = [
    'C',
    'CE',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '±',
    '0',
    '.',
    '=',
  ];

  static const scientific = [
    '2nd',
    'sin',
    'cos',
    'tan',
    'ln',
    'log',
    'x²',
    '√',
    'x^y',
    '(',
    ')',
    '÷',
    'MC',
    '7',
    '8',
    '9',
    'C',
    '×',
    'MR',
    '4',
    '5',
    '6',
    'CE',
    '-',
    'M+',
    '1',
    '2',
    '3',
    '%',
    '+',
    'M-',
    '±',
    '0',
    '.',
    'π',
    '=',
  ];

  static const scientificSecond = [
    '2nd',
    'asin',
    'acos',
    'atan',
    'e',
    'log₂',
    'x³',
    '∛',
    'x^y',
    '(',
    ')',
    '÷',
    'MC',
    '7',
    '8',
    '9',
    'C',
    '×',
    'MR',
    '4',
    '5',
    '6',
    'CE',
    '-',
    'M+',
    '1',
    '2',
    '3',
    '%',
    '+',
    'M-',
    '±',
    '0',
    '.',
    'π',
    '=',
  ];

  static const programmer = [
    'DEC',
    'BIN',
    'OCT',
    'HEX',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'AND',
    'OR',
    'XOR',
    'NOT',
    '<<',
    '>>',
    '7',
    '8',
    '9',
    'CE',
    '4',
    '5',
    '6',
    '=',
    '1',
    '2',
    '3',
    '+',
    '±',
    '0',
    // CLR is clear-all in Programmer mode. The C label is reserved for hex digit C.
    'CLR',
    '-',
  ];
}
