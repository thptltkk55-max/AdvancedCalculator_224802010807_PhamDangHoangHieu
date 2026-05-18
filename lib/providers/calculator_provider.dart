import 'package:flutter/foundation.dart';

import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';
import '../models/calculator_settings.dart';
import '../services/storage_service.dart';
import '../utils/calculator_logic.dart';
import '../utils/expression_parser.dart';

class CalculatorProvider extends ChangeNotifier {
  static const _standardOperators = {'+', '-', '×', '÷', '*', '/', '%', '^'};
  static const _programmerOperators = {
    'AND',
    'OR',
    'XOR',
    'NOT',
    '<<',
    '>>',
    '+',
    '-',
  };
  static const _programmerBaseLabels = {'DEC', 'BIN', 'OCT', 'HEX'};
  static const _programmerActionLabels = {'CE', 'CLR', '=', '±'};

  String expression = '';
  String result = '0';
  CalculatorMode mode = CalculatorMode.basic;
  AngleMode angleMode = AngleMode.degrees;
  double memory = 0;
  bool hasMemory = false;
  bool secondFunctions = false;
  ProgrammerBase programmerBase = ProgrammerBase.decimal;
  CalculatorSettings settings = const CalculatorSettings();
  CalculationHistory? _lastCalculation;

  int get decimalPrecision => settings.decimalPrecision;

  CalculationHistory? consumeLastCalculation() {
    final item = _lastCalculation;
    _lastCalculation = null;
    return item;
  }

  Future<void> loadSettings() async {
    settings = await StorageService.loadSettings();
    angleMode = settings.angleMode;
    notifyListeners();
  }

  Future<void> updateSettings(CalculatorSettings value) async {
    settings = value;
    angleMode = value.angleMode;
    await StorageService.saveSettings(settings);
    notifyListeners();
  }

  void addToExpression(String value) {
    if (_isCommand(value)) {
      _handleCommand(value);
      return;
    }

    if (mode == CalculatorMode.programmer) {
      _addProgrammerToken(value);
    } else {
      _addStandardToken(value);
    }
    notifyListeners();
  }

  void calculate() {
    final source = expression.trim();
    if (source.isEmpty) {
      result = '0';
      notifyListeners();
      return;
    }

    try {
      final calculated = mode == CalculatorMode.programmer
          ? CalculatorLogic.evaluateProgrammer(source, programmerBase)
          : CalculatorLogic.evaluate(
              source,
              angleMode: angleMode,
              precision: decimalPrecision,
            );
      result = calculated;
      _lastCalculation = CalculationHistory(
        expression: source,
        result: calculated,
        timestamp: DateTime.now(),
      );
      expression = calculated;
    } on CalculatorException catch (error) {
      result = error.message;
    } on FormatException {
      result = 'Gia tri khong hop le';
    } catch (_) {
      result = 'Loi tinh toan';
    }
    notifyListeners();
  }

  void clear() {
    expression = '';
    result = '0';
    _lastCalculation = null;
    notifyListeners();
  }

  void clearEntry() {
    if (_hasErrorResult()) {
      clear();
      return;
    }

    final source = expression.trimRight();
    if (source.isEmpty) {
      result = '0';
      notifyListeners();
      return;
    }

    expression = mode == CalculatorMode.programmer
        ? _clearProgrammerEntry(source)
        : _clearStandardEntry(source);
    result = '0';
    notifyListeners();
  }

  void deleteLast() {
    if (_hasErrorResult()) {
      clear();
      return;
    }
    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1).trimRight();
      if (expression.isEmpty) {
        result = '0';
      }
      notifyListeners();
    } else {
      result = '0';
      notifyListeners();
    }
  }

  String _clearStandardEntry(String source) {
    if (_endsWithBinaryOperator(source)) {
      return source;
    }
    final operatorIndex = _lastBinaryOperatorIndex(source);
    if (operatorIndex == -1) {
      return '';
    }
    return source.substring(0, operatorIndex + 1).trimRight();
  }

  String _clearProgrammerEntry(String source) {
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length <= 1) {
      return '';
    }
    if (_programmerOperators.contains(parts.last)) {
      return source;
    }
    parts.removeLast();
    return parts.join(' ');
  }

  int _lastBinaryOperatorIndex(String source) {
    for (var index = source.length - 1; index >= 0; index--) {
      final char = source[index];
      if (!_standardOperators.contains(char)) {
        continue;
      }
      if (char == '-' && _isUnaryMinus(source, index)) {
        continue;
      }
      return index;
    }
    return -1;
  }

  bool _endsWithBinaryOperator(String source) {
    if (source.isEmpty) {
      return false;
    }
    final lastIndex = source.length - 1;
    final last = source[lastIndex];
    return _standardOperators.contains(last) &&
        !(last == '-' && _isUnaryMinus(source, lastIndex));
  }

  bool _isUnaryMinus(String source, int index) {
    if (source[index] != '-') {
      return false;
    }
    var previousIndex = index - 1;
    while (previousIndex >= 0 && source[previousIndex].trim().isEmpty) {
      previousIndex--;
    }
    if (previousIndex < 0) {
      return true;
    }
    final previous = source[previousIndex];
    return _standardOperators.contains(previous) || previous == '(';
  }

  bool _hasErrorResult() {
    const errorPrefixes = [
      'Bieu thuc',
      'Gia tri',
      'Giai thua',
      'Ham',
      'Ket qua',
      'Khong',
      'Ky tu',
      'Log',
      'Loi',
      'So thap phan',
      'Thieu',
    ];
    return errorPrefixes.any(result.startsWith);
  }

  void toggleSign() {
    if (mode == CalculatorMode.programmer) {
      if (expression.startsWith('-')) {
        expression = expression.substring(1);
      } else if (expression.isNotEmpty) {
        expression = '-$expression';
      }
      notifyListeners();
      return;
    }

    if (expression.isEmpty) {
      expression = '-';
    } else {
      expression = '-($expression)';
    }
    notifyListeners();
  }

  void addPercentage() {
    if (mode == CalculatorMode.programmer) {
      return;
    }
    expression += '%';
    notifyListeners();
  }

  void addScientificFunction(String function) {
    switch (function) {
      case '2nd':
        secondFunctions = !secondFunctions;
        break;
      case 'x²':
        expression += '^2';
        break;
      case 'x³':
        expression += '^3';
        break;
      case 'x^y':
        expression += '^';
        break;
      case '√':
        expression += 'sqrt(';
        break;
      case '∛':
        expression += 'cbrt(';
        break;
      case 'log₂':
        expression += 'log2(';
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'asin':
      case 'acos':
      case 'atan':
      case 'ln':
      case 'log':
        expression += '$function(';
        break;
      case 'π':
        expression += 'π';
        break;
      case 'e':
        expression += 'e';
        break;
      default:
        expression += function;
    }
    notifyListeners();
  }

  void toggleMode(CalculatorMode nextMode) {
    mode = nextMode;
    expression = '';
    result = '0';
    notifyListeners();
  }

  Future<void> toggleAngleMode() async {
    final next = angleMode == AngleMode.degrees
        ? AngleMode.radians
        : AngleMode.degrees;
    await updateSettings(settings.copyWith(angleMode: next));
  }

  void memoryAdd() {
    final value = _currentNumericValue();
    memory += value;
    hasMemory = true;
    notifyListeners();
  }

  void memorySubtract() {
    final value = _currentNumericValue();
    memory -= value;
    hasMemory = true;
    notifyListeners();
  }

  void memoryRecall() {
    expression = ExpressionParser.formatNumber(
      memory,
      precision: decimalPrecision,
    );
    result = expression;
    notifyListeners();
  }

  void memoryClear() {
    memory = 0;
    hasMemory = false;
    notifyListeners();
  }

  void useHistory(CalculationHistory item) {
    expression = item.expression;
    result = item.result;
    notifyListeners();
  }

  void setProgrammerBase(ProgrammerBase base) {
    try {
      final value = CalculatorLogic.parseProgrammerValue(
        expression.isEmpty ? result : expression,
        programmerBase,
      );
      programmerBase = base;
      expression = CalculatorLogic.formatProgrammerValue(value, base);
      result = expression;
    } catch (_) {
      programmerBase = base;
      expression = '';
      result = '0';
    }
    notifyListeners();
  }

  Map<ProgrammerBase, String> programmerBaseValues() {
    try {
      final value = CalculatorLogic.parseProgrammerValue(
        expression.isEmpty ? result : expression.split(RegExp(r'\s+')).last,
        programmerBase,
      );
      return CalculatorLogic.convertIntegerToBases(value);
    } catch (_) {
      return CalculatorLogic.convertIntegerToBases(0);
    }
  }

  bool isProgrammerDigitEnabled(String value) {
    if (value.length != 1) {
      return true;
    }
    final digit = int.tryParse(value, radix: 16);
    return digit != null && digit < programmerBase.radix;
  }

  bool isProgrammerButtonEnabled(String value) {
    if (_programmerBaseLabels.contains(value) ||
        _programmerActionLabels.contains(value) ||
        _programmerOperators.contains(value)) {
      return true;
    }
    return isProgrammerDigitEnabled(value);
  }

  bool _isCommand(String value) {
    if (mode == CalculatorMode.programmer && value == 'C') {
      return false;
    }
    return {
      '=',
      'C',
      'CLR',
      'CE',
      '±',
      '%',
      'MC',
      'MR',
      'M+',
      'M-',
      '2nd',
      'x²',
      'x³',
      'x^y',
      '√',
      '∛',
      'sin',
      'cos',
      'tan',
      'asin',
      'acos',
      'atan',
      'ln',
      'log',
      'log₂',
      'π',
      'e',
      'DEC',
      'BIN',
      'OCT',
      'HEX',
    }.contains(value);
  }

  void _handleCommand(String value) {
    switch (value) {
      case '=':
        calculate();
        break;
      case 'C':
      case 'CLR':
        clear();
        break;
      case 'CE':
        clearEntry();
        break;
      case '±':
        toggleSign();
        break;
      case '%':
        addPercentage();
        break;
      case 'MC':
        memoryClear();
        break;
      case 'MR':
        memoryRecall();
        break;
      case 'M+':
        memoryAdd();
        break;
      case 'M-':
        memorySubtract();
        break;
      case 'DEC':
        setProgrammerBase(ProgrammerBase.decimal);
        break;
      case 'BIN':
        setProgrammerBase(ProgrammerBase.binary);
        break;
      case 'OCT':
        setProgrammerBase(ProgrammerBase.octal);
        break;
      case 'HEX':
        setProgrammerBase(ProgrammerBase.hexadecimal);
        break;
      default:
        addScientificFunction(value);
    }
  }

  void _addStandardToken(String value) {
    if (_shouldKeepReadableSpacing(value)) {
      expression += ' $value';
      return;
    }
    expression += value;
  }

  bool _shouldKeepReadableSpacing(String value) {
    if (expression.length < 2 || value.length != 1) {
      return false;
    }
    final last = expression[expression.length - 1];
    final beforeLast = expression[expression.length - 2];
    return _standardOperators.contains(last) && beforeLast.trim().isEmpty;
  }

  void _addProgrammerToken(String value) {
    if (value == 'NOT') {
      expression = expression.trim().isEmpty ? 'NOT ' : 'NOT ${expression.trim()}';
      return;
    }
    if ({'AND', 'OR', 'XOR', '<<', '>>', '+', '-'}.contains(value)) {
      expression = expression.trimRight();
      if (expression.isNotEmpty && !expression.endsWith(' ')) {
        expression += ' ';
      }
      expression += '$value ';
      return;
    }
    if (value == '.') {
      return;
    }
    if (isProgrammerDigitEnabled(value)) {
      expression += value;
    }
  }

  double _currentNumericValue() {
    try {
      return double.parse(result);
    } catch (_) {
      try {
        return ExpressionParser(angleMode: angleMode).evaluate(expression);
      } catch (_) {
        return 0;
      }
    }
  }
}
