import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({
    super.key,
    required this.onPressed,
    required this.onLongPress,
  });

  final ValueChanged<String> onPressed;
  final ValueChanged<String> onLongPress;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calculator, _) {
        final buttons = switch (calculator.mode) {
          CalculatorMode.basic => CalculatorButtons.basic,
          CalculatorMode.scientific => calculator.secondFunctions
              ? CalculatorButtons.scientificSecond
              : CalculatorButtons.scientific,
          CalculatorMode.programmer => CalculatorButtons.programmer,
        };
        final crossAxisCount =
            calculator.mode == CalculatorMode.scientific ? 6 : 4;
        final rowCount = (buttons.length / crossAxisCount).ceil();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: LayoutBuilder(
            key: ValueKey('${calculator.mode}-${calculator.secondFunctions}'),
            builder: (context, constraints) {
              final gap = constraints.maxHeight < 330 ? 5.0 : 7.0;
              return Column(
                children: List.generate(rowCount, (rowIndex) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: rowIndex == rowCount - 1 ? 0 : gap,
                      ),
                      child: Row(
                        children: List.generate(crossAxisCount, (columnIndex) {
                          final index = rowIndex * crossAxisCount + columnIndex;
                          if (index >= buttons.length) {
                            return const Expanded(child: SizedBox.shrink());
                          }
                          final label = buttons[index];
                          final selected = _isSelectedBase(label, calculator);
                          final enabled = calculator.mode ==
                                  CalculatorMode.programmer
                              ? calculator.isProgrammerButtonEnabled(label)
                              : true;
                          final kind = _buttonKind(label, calculator.mode);
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: columnIndex == crossAxisCount - 1
                                    ? 0
                                    : gap,
                              ),
                              child: CalculatorButton(
                                label: label,
                                selected: selected,
                                enabled: enabled,
                                kind: kind,
                                tooltip: _tooltip(label, calculator.mode, selected),
                                onPressed: () => onPressed(label),
                                onLongPress: () => onLongPress(label),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }

  bool _isSelectedBase(String label, CalculatorProvider calculator) {
    return calculator.mode == CalculatorMode.programmer &&
        calculator.programmerBase.label == label;
  }

  CalculatorButtonKind _buttonKind(String label, CalculatorMode mode) {
    if (mode == CalculatorMode.programmer &&
        {'DEC', 'BIN', 'OCT', 'HEX'}.contains(label)) {
      return CalculatorButtonKind.base;
    }
    if ({
      '+',
      '-',
      '×',
      '÷',
      '=',
      'AND',
      'OR',
      'XOR',
      'NOT',
      '<<',
      '>>',
    }.contains(label)) {
      return CalculatorButtonKind.operator;
    }
    if ({
      'C',
      'CLR',
      'CE',
      'MC',
      'MR',
      'M+',
      'M-',
      '2nd',
      'DEC',
      'BIN',
      'OCT',
      'HEX',
    }.contains(label)) {
      return CalculatorButtonKind.function;
    }
    return CalculatorButtonKind.standard;
  }

  String? _tooltip(String label, CalculatorMode mode, bool selected) {
    if (mode != CalculatorMode.programmer ||
        !{'DEC', 'BIN', 'OCT', 'HEX'}.contains(label)) {
      return null;
    }
    return selected ? '$label base selected' : 'Switch to $label base';
  }
}
