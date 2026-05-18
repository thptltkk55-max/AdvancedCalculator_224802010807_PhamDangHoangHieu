import 'package:calculator/main.dart';
import 'package:calculator/widgets/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('calculator app renders compact mode selector', (tester) async {
    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.text('Advanced Calculator'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Scientific'), findsOneWidget);
    expect(find.text('Programmer'), findsOneWidget);
    expect(find.text('DEG'), findsNothing);
  });

  testWidgets('mode switching updates visible calculator controls', (
    tester,
  ) async {
    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scientific'));
    await tester.pumpAndSettle();
    expect(find.text('DEG'), findsOneWidget);
    expect(find.text('sin'), findsOneWidget);

    await tester.tap(find.text('Programmer'));
    await tester.pumpAndSettle();
    expect(find.text('DEC'), findsWidgets);
    expect(find.text('AND'), findsOneWidget);
  });

  testWidgets('calculator fits a common small phone viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scientific'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Programmer'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('C and CE buttons clear the expected calculator state', (
    tester,
  ) async {
    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    for (final label in ['1', '2', '+', '8', '5']) {
      await tester.tap(find.text(label));
      await tester.pump();
    }

    expect(find.text('12+85'), findsOneWidget);

    await tester.tap(find.text('CE'));
    await tester.pump();
    expect(find.text('12+'), findsOneWidget);
    expect(find.text('12+85'), findsNothing);

    await tester.tap(find.text('C'));
    await tester.pump();
    expect(find.text('12+'), findsNothing);
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('scientific display handles long expressions without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scientific'));
    await tester.pumpAndSettle();

    for (final label in [
      'sin',
      '3',
      '0',
      ')',
      '+',
      'cos',
      '4',
      '5',
      ')',
      '+',
      'tan',
      '6',
      '0',
      ')',
    ]) {
      await tester.tap(
        find.widgetWithText(CalculatorButton, label),
        warnIfMissed: false,
      );
      await tester.pump();
    }

    expect(find.text('DEG'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(
      find.widgetWithText(CalculatorButton, '='),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('programmer mode shows clear selected and disabled states', (
    tester,
  ) async {
    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Programmer'));
    await tester.pumpAndSettle();

    expect(_button(tester, 'DEC').selected, isTrue);
    for (final label in ['A', 'B', 'C', 'D', 'E', 'F']) {
      expect(_button(tester, label).enabled, isFalse);
    }
    for (final label in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) {
      expect(_button(tester, label).enabled, isTrue);
    }

    await tester.tap(find.widgetWithText(CalculatorButton, 'BIN'));
    await tester.pumpAndSettle();
    expect(_button(tester, 'BIN').selected, isTrue);
    expect(_button(tester, '0').enabled, isTrue);
    expect(_button(tester, '1').enabled, isTrue);
    for (final label in ['2', '3', '4', '5', '6', '7', '8', '9', 'A', 'F']) {
      expect(_button(tester, label).enabled, isFalse);
    }

    await tester.tap(find.widgetWithText(CalculatorButton, 'OCT'));
    await tester.pumpAndSettle();
    expect(_button(tester, 'OCT').selected, isTrue);
    for (final label in ['0', '1', '2', '3', '4', '5', '6', '7']) {
      expect(_button(tester, label).enabled, isTrue);
    }
    for (final label in ['8', '9', 'A', 'F']) {
      expect(_button(tester, label).enabled, isFalse);
    }

    await tester.tap(find.widgetWithText(CalculatorButton, 'HEX'));
    await tester.pumpAndSettle();
    expect(_button(tester, 'HEX').selected, isTrue);
    for (final label in ['0', '9', 'A', 'B', 'C', 'D', 'E', 'F']) {
      expect(_button(tester, label).enabled, isTrue);
    }
  });

  testWidgets('settings screen renders compact content without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdvancedCalculatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Decimal Precision'), findsOneWidget);
    expect(find.text('Angle Mode'), findsOneWidget);
    expect(find.text('History Size'), findsOneWidget);
    expect(find.text('Clear All History'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final clearButtonBottom = tester
        .getBottomRight(find.widgetWithText(FilledButton, 'Clear All History'))
        .dy;
    expect(clearButtonBottom, lessThanOrEqualTo(640));
  });
}

CalculatorButton _button(WidgetTester tester, String label) {
  return tester.widget<CalculatorButton>(
    find.widgetWithText(CalculatorButton, label),
  );
}
