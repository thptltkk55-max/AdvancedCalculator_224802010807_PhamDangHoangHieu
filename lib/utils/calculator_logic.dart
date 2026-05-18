import '../models/calculator_mode.dart';
import 'expression_parser.dart';

class CalculatorLogic {
  static String evaluate(
    String expression, {
    AngleMode angleMode = AngleMode.degrees,
    int precision = 6,
  }) {
    if (expression.trim().isEmpty) {
      return '0';
    }
    return ExpressionParser(
      angleMode: angleMode,
    ).evaluateToString(expression, precision: precision);
  }

  static int parseProgrammerValue(String value, ProgrammerBase base) {
    final normalized = value.trim().replaceAll(' ', '').toUpperCase();
    if (normalized.isEmpty) {
      return 0;
    }
    final sign = normalized.startsWith('-') ? -1 : 1;
    final unsigned = normalized.replaceFirst('-', '');
    return sign * int.parse(unsigned, radix: base.radix);
  }

  static String formatProgrammerValue(int value, ProgrammerBase base) {
    if (base == ProgrammerBase.decimal) {
      return value.toString();
    }
    if (value < 0) {
      return '-${(-value).toRadixString(base.radix).toUpperCase()}';
    }
    return value.toRadixString(base.radix).toUpperCase();
  }

  static Map<ProgrammerBase, String> convertIntegerToBases(int value) {
    return {
      ProgrammerBase.decimal: value.toString(),
      ProgrammerBase.binary: value.toRadixString(2).toUpperCase(),
      ProgrammerBase.octal: value.toRadixString(8).toUpperCase(),
      ProgrammerBase.hexadecimal: value.toRadixString(16).toUpperCase(),
    };
  }

  static String evaluateProgrammer(
    String expression,
    ProgrammerBase base,
  ) {
    final parts = expression.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '0';
    }

    if (parts.length == 2 && parts.first == 'NOT') {
      final value = parseProgrammerValue(parts[1], base);
      return formatProgrammerValue(~value, base);
    }

    var value = parseProgrammerValue(parts.first, base);
    var index = 1;
    while (index < parts.length) {
      final operator = parts[index];
      if (index + 1 >= parts.length) {
        throw const CalculatorException('Thieu toan hang');
      }
      final right = parseProgrammerValue(parts[index + 1], base);
      switch (operator) {
        case 'AND':
          value &= right;
          break;
        case 'OR':
          value |= right;
          break;
        case 'XOR':
          value ^= right;
          break;
        case '<<':
          value <<= right;
          break;
        case '>>':
          value >>= right;
          break;
        case '+':
          value += right;
          break;
        case '-':
          value -= right;
          break;
        default:
          throw CalculatorException('Phep toan khong ho tro: $operator');
      }
      index += 2;
    }

    return formatProgrammerValue(value, base);
  }
}
