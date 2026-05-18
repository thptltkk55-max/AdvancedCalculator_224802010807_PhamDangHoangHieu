import 'package:calculator/providers/calculator_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorProvider clear controls', () {
    test('C clears expression and result without clearing memory', () {
      final provider = CalculatorProvider()
        ..result = '10'
        ..memoryAdd()
        ..expression = '12 + 8'
        ..result = '20';

      provider.clear();

      expect(provider.expression, isEmpty);
      expect(provider.result, '0');
      expect(provider.memory, 10);
      expect(provider.hasMemory, isTrue);
    });

    test('CE clears only the current entry after an operator', () {
      final provider = CalculatorProvider()..expression = '12 + 85';

      provider.clearEntry();

      expect(provider.expression, '12 +');
      expect(provider.result, '0');
    });

    test('CE clears a single number expression', () {
      final provider = CalculatorProvider()
        ..expression = '45'
        ..result = '45';

      provider.clearEntry();

      expect(provider.expression, isEmpty);
      expect(provider.result, '0');
    });

    test('CE lets the user enter a replacement number', () {
      final provider = CalculatorProvider()..expression = '12 + 85';

      provider.clearEntry();
      provider.addToExpression('7');

      expect(provider.expression, '12 + 7');
    });

    test('CE does not clear memory', () {
      final provider = CalculatorProvider()
        ..result = '5'
        ..memoryAdd()
        ..expression = '12 + 85';

      provider.clearEntry();

      expect(provider.memory, 5);
      expect(provider.hasMemory, isTrue);
    });

    test('deleteLast removes exactly one character', () {
      final provider = CalculatorProvider()..expression = '123';

      provider.deleteLast();

      expect(provider.expression, '12');
    });
  });
}
