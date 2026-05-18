import 'dart:math' as math;

import '../models/calculator_mode.dart';

class CalculatorException implements Exception {
  const CalculatorException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ExpressionParser {
  ExpressionParser({
    this.angleMode = AngleMode.degrees,
  });

  final AngleMode angleMode;

  double evaluate(String expression) {
    final tokens = _Tokenizer(expression).tokenize();
    final normalizedTokens = _insertImplicitMultiplication(tokens);
    final parser = _Parser(normalizedTokens, angleMode);
    final value = parser.parseExpression();
    if (!parser.isAtEnd) {
      throw const CalculatorException('Bieu thuc khong hop le');
    }
    if (value.isNaN || value.isInfinite) {
      throw const CalculatorException('Ket qua khong hop le');
    }
    return value;
  }

  String evaluateToString(
    String expression, {
    int precision = 6,
  }) {
    final value = evaluate(expression);
    return formatNumber(value, precision: precision);
  }

  static String formatNumber(double value, {int precision = 6}) {
    if (value.isNaN || value.isInfinite) {
      throw const CalculatorException('Ket qua khong hop le');
    }

    final rounded = value.toStringAsFixed(precision);
    final trimmed = rounded
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
    if (trimmed == '-0') {
      return '0';
    }
    return trimmed;
  }
}

enum _TokenType {
  number,
  identifier,
  operator,
  leftParen,
  rightParen,
  factorial,
}

class _Token {
  const _Token(this.type, this.value);

  final _TokenType type;
  final String value;

  bool get startsValue =>
      type == _TokenType.number ||
      type == _TokenType.identifier ||
      type == _TokenType.leftParen;

  bool get endsValue =>
      type == _TokenType.number ||
      type == _TokenType.identifier ||
      type == _TokenType.rightParen ||
      type == _TokenType.factorial;
}

class _Tokenizer {
  _Tokenizer(String expression) : _source = _normalize(expression);

  final String _source;
  int _index = 0;

  List<_Token> tokenize() {
    final tokens = <_Token>[];

    while (_index < _source.length) {
      final char = _source[_index];
      if (char.trim().isEmpty) {
        _index++;
        continue;
      }
      if (_isDigit(char) || char == '.') {
        tokens.add(_readNumber());
        continue;
      }
      if (_isLetter(char)) {
        tokens.add(_readIdentifier());
        continue;
      }
      if ('+-*/^%'.contains(char)) {
        tokens.add(_Token(_TokenType.operator, char));
        _index++;
        continue;
      }
      if (char == '(') {
        tokens.add(const _Token(_TokenType.leftParen, '('));
        _index++;
        continue;
      }
      if (char == ')') {
        tokens.add(const _Token(_TokenType.rightParen, ')'));
        _index++;
        continue;
      }
      if (char == '!') {
        tokens.add(const _Token(_TokenType.factorial, '!'));
        _index++;
        continue;
      }
      throw CalculatorException('Ky tu khong hop le: $char');
    }

    return tokens;
  }

  static String _normalize(String input) {
    return input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        .replaceAll('∛', 'cbrt')
        .replaceAll('log₂', 'log2')
        .replaceAll(',', '.');
  }

  _Token _readNumber() {
    final start = _index;
    var dotCount = 0;
    while (_index < _source.length) {
      final char = _source[_index];
      if (char == '.') {
        dotCount++;
        if (dotCount > 1) {
          throw const CalculatorException('So thap phan khong hop le');
        }
      } else if (!_isDigit(char)) {
        break;
      }
      _index++;
    }
    return _Token(_TokenType.number, _source.substring(start, _index));
  }

  _Token _readIdentifier() {
    final start = _index;
    while (_index < _source.length && _isLetterOrDigit(_source[_index])) {
      _index++;
    }
    return _Token(_TokenType.identifier, _source.substring(start, _index));
  }

  bool _isDigit(String char) => RegExp(r'\d').hasMatch(char);

  bool _isLetter(String char) => RegExp(r'[A-Za-z]').hasMatch(char);

  bool _isLetterOrDigit(String char) => RegExp(r'[A-Za-z0-9]').hasMatch(char);
}

List<_Token> _insertImplicitMultiplication(List<_Token> tokens) {
  final result = <_Token>[];
  const functions = {
    'sin',
    'cos',
    'tan',
    'asin',
    'acos',
    'atan',
    'ln',
    'log',
    'log2',
    'sqrt',
    'cbrt',
  };

  for (var i = 0; i < tokens.length; i++) {
    final token = tokens[i];
    if (result.isNotEmpty) {
      final previous = result.last;
      final currentIsFunction = token.type == _TokenType.identifier &&
          functions.contains(token.value.toLowerCase());
      final previousIsFunction = previous.type == _TokenType.identifier &&
          functions.contains(previous.value.toLowerCase());
      final shouldMultiply =
          previous.endsValue &&
          token.startsValue &&
          !currentIsFunction &&
          !previousIsFunction;
      if (shouldMultiply) {
        result.add(const _Token(_TokenType.operator, '*'));
      }
    }
    result.add(token);
  }

  return result;
}

class _Parser {
  _Parser(this.tokens, this.angleMode);

  final List<_Token> tokens;
  final AngleMode angleMode;
  int _position = 0;

  bool get isAtEnd => _position >= tokens.length;

  double parseExpression() => _parseAdditive();

  double _parseAdditive() {
    var value = _parseMultiplicative();
    while (_matchOperator('+') || _matchOperator('-')) {
      final operator = _previous.value;
      final right = _parseMultiplicative();
      value = operator == '+' ? value + right : value - right;
    }
    return value;
  }

  double _parseMultiplicative() {
    var value = _parsePower();
    while (_matchOperator('*') || _matchOperator('/')) {
      final operator = _previous.value;
      final right = _parsePower();
      if (operator == '/') {
        if (right == 0) {
          throw const CalculatorException('Khong the chia cho 0');
        }
        value /= right;
      } else {
        value *= right;
      }
    }
    return value;
  }

  double _parsePower() {
    var value = _parseUnary();
    if (_matchOperator('^')) {
      final exponent = _parsePower();
      value = math.pow(value, exponent).toDouble();
    }
    return value;
  }

  double _parseUnary() {
    if (_matchOperator('+')) {
      return _parseUnary();
    }
    if (_matchOperator('-')) {
      return -_parseUnary();
    }
    return _parsePostfix();
  }

  double _parsePostfix() {
    var value = _parsePrimary();
    while (true) {
      if (_match(_TokenType.factorial)) {
        value = _factorial(value);
      } else if (_matchOperator('%')) {
        value /= 100;
      } else {
        break;
      }
    }
    return value;
  }

  double _parsePrimary() {
    if (_match(_TokenType.number)) {
      final value = double.tryParse(_previous.value);
      if (value == null) {
        throw const CalculatorException('So khong hop le');
      }
      return value;
    }

    if (_match(_TokenType.identifier)) {
      final name = _previous.value.toLowerCase();
      if (name == 'pi') {
        return math.pi;
      }
      if (name == 'e') {
        return math.e;
      }
      return _parseFunction(name);
    }

    if (_match(_TokenType.leftParen)) {
      final value = parseExpression();
      if (!_match(_TokenType.rightParen)) {
        throw const CalculatorException('Thieu dau dong ngoac');
      }
      return value;
    }

    throw const CalculatorException('Bieu thuc khong hop le');
  }

  double _parseFunction(String name) {
    final supported = {
      'sin',
      'cos',
      'tan',
      'asin',
      'acos',
      'atan',
      'ln',
      'log',
      'log2',
      'sqrt',
      'cbrt',
    };
    if (!supported.contains(name)) {
      throw CalculatorException('Ham khong ho tro: $name');
    }

    double argument;
    if (_match(_TokenType.leftParen)) {
      argument = parseExpression();
      if (!_match(_TokenType.rightParen)) {
        throw const CalculatorException('Thieu dau dong ngoac');
      }
    } else {
      argument = _parseUnary();
    }

    switch (name) {
      case 'sin':
        return math.sin(_toRadians(argument));
      case 'cos':
        return math.cos(_toRadians(argument));
      case 'tan':
        return math.tan(_toRadians(argument));
      case 'asin':
        return _fromRadians(math.asin(argument));
      case 'acos':
        return _fromRadians(math.acos(argument));
      case 'atan':
        return _fromRadians(math.atan(argument));
      case 'ln':
        _ensurePositiveLog(argument);
        return math.log(argument);
      case 'log':
        _ensurePositiveLog(argument);
        return math.log(argument) / math.ln10;
      case 'log2':
        _ensurePositiveLog(argument);
        return math.log(argument) / math.ln2;
      case 'sqrt':
        if (argument < 0) {
          throw const CalculatorException('Khong the lay can bac hai so am');
        }
        return math.sqrt(argument);
      case 'cbrt':
        return argument < 0
            ? -math.pow(-argument, 1 / 3).toDouble()
            : math.pow(argument, 1 / 3).toDouble();
    }
    throw CalculatorException('Ham khong ho tro: $name');
  }

  void _ensurePositiveLog(double value) {
    if (value <= 0) {
      throw const CalculatorException('Log chi nhan so duong');
    }
  }

  double _factorial(double value) {
    if (value < 0 || value % 1 != 0 || value > 170) {
      throw const CalculatorException('Giai thua khong hop le');
    }
    var result = 1.0;
    for (var i = 2; i <= value.toInt(); i++) {
      result *= i;
    }
    return result;
  }

  double _toRadians(double value) {
    return angleMode == AngleMode.degrees ? value * math.pi / 180 : value;
  }

  double _fromRadians(double value) {
    return angleMode == AngleMode.degrees ? value * 180 / math.pi : value;
  }

  bool _match(_TokenType type) {
    if (isAtEnd || tokens[_position].type != type) {
      return false;
    }
    _position++;
    return true;
  }

  bool _matchOperator(String operator) {
    if (isAtEnd ||
        tokens[_position].type != _TokenType.operator ||
        tokens[_position].value != operator) {
      return false;
    }
    _position++;
    return true;
  }

  _Token get _previous => tokens[_position - 1];
}
