import 'package:calculator/models/calculator_mode.dart';
import 'package:calculator/utils/calculator_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorLogic.evaluate', () {
    test('5 + 3 = 8', () {
      expect(CalculatorLogic.evaluate('5 + 3'), '8');
    });

    test('10 - 4 = 6', () {
      expect(CalculatorLogic.evaluate('10 - 4'), '6');
    });

    test('6 * 7 = 42', () {
      expect(CalculatorLogic.evaluate('6 * 7'), '42');
    });

    test('15 / 3 = 5', () {
      expect(CalculatorLogic.evaluate('15 / 3'), '5');
    });

    test('operator precedence works', () {
      expect(CalculatorLogic.evaluate('2 + 3 * 4'), '14');
    });

    test('parentheses override precedence', () {
      expect(CalculatorLogic.evaluate('(2 + 3) * 4'), '20');
    });

    test('mixed expression returns expected result', () {
      expect(CalculatorLogic.evaluate('(5 + 3) * 2 - 4 / 2'), '14');
    });

    test('nested parentheses return expected result', () {
      expect(CalculatorLogic.evaluate('((2 + 3) * (4 - 1)) / 5'), '3');
    });

    test('division by zero throws clear error', () {
      expect(
        () => CalculatorLogic.evaluate('1 / 0'),
        throwsA(predicate((error) => error.toString().contains('chia cho 0'))),
      );
    });

    test('sqrt negative throws clear error', () {
      expect(
        () => CalculatorLogic.evaluate('sqrt(-9)'),
        throwsA(predicate((error) => error.toString().contains('so am'))),
      );
    });

    test('sin(30) in DEG is close to 0.5', () {
      final result = double.parse(
        CalculatorLogic.evaluate(
          'sin(30)',
          angleMode: AngleMode.degrees,
          precision: 8,
        ),
      );
      expect(result, closeTo(0.5, 0.000001));
    });
  });

  group('CalculatorLogic.evaluateProgrammer', () {
    test('AND works in hexadecimal mode', () {
      expect(
        CalculatorLogic.evaluateProgrammer(
          'F AND A',
          ProgrammerBase.hexadecimal,
        ),
        'A',
      );
    });

    test('OR works in binary mode', () {
      expect(
        CalculatorLogic.evaluateProgrammer(
          '1010 OR 0101',
          ProgrammerBase.binary,
        ),
        '1111',
      );
    });
  });
}
