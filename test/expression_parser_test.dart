import 'package:calculator/models/calculator_mode.dart';
import 'package:calculator/utils/expression_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressionParser', () {
    test('converts display operators before evaluation', () {
      final parser = ExpressionParser();
      expect(parser.evaluateToString('8 ÷ 2 × 3'), '12');
    });

    test('supports implicit multiplication with pi', () {
      final parser = ExpressionParser();
      expect(parser.evaluateToString('2π', precision: 4), '6.2832');
    });

    test('supports exponent operator', () {
      final parser = ExpressionParser();
      expect(parser.evaluateToString('2^3'), '8');
    });

    test('supports log2', () {
      final parser = ExpressionParser();
      expect(parser.evaluateToString('log2(8)'), '3');
    });

    test('uses radians when requested', () {
      final parser = ExpressionParser(angleMode: AngleMode.radians);
      expect(parser.evaluateToString('sin(0)'), '0');
    });
  });
}
