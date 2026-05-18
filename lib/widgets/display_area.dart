import 'package:flutter/material.dart';

import '../models/calculator_mode.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({
    super.key,
    required this.expression,
    required this.result,
    required this.angleMode,
    required this.hasMemory,
    required this.mode,
    required this.programmerBase,
  });

  final String expression;
  final String result;
  final AngleMode angleMode;
  final bool hasMemory;
  final CalculatorMode mode;
  final ProgrammerBase programmerBase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showStatus = mode != CalculatorMode.basic || hasMemory;
    final isProgrammer = mode == CalculatorMode.programmer;
    final isScientific = mode == CalculatorMode.scientific;
    final verticalPadding = isProgrammer ? 7.0 : 9.0;
    final horizontalPadding = isProgrammer ? 10.0 : 12.0;
    final statusGap = isProgrammer ? 4.0 : (isScientific ? 5.0 : 6.0);
    final resultGap = isProgrammer ? 4.0 : (isScientific ? 5.0 : 8.0);
    final expressionFontSize = isProgrammer ? 15.0 : (isScientific ? 16.0 : 18.0);
    final resultFontSize = isProgrammer ? 30.0 : (isScientific ? 32.0 : 34.0);
    final resultHeight = isProgrammer ? 32.0 : (isScientific ? 36.0 : 40.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showStatus) ...[
            _StatusRow(
              mode: mode,
              angleMode: angleMode,
              hasMemory: hasMemory,
              programmerBase: programmerBase,
            ),
            SizedBox(height: statusGap),
          ],
          Expanded(
            child: _DisplayLine(
              text: expression,
              emptyText: isScientific ? '' : '0',
              fontSize: expressionFontSize,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
              alignment: Alignment.bottomRight,
            ),
          ),
          SizedBox(height: resultGap),
          SizedBox(
            height: resultHeight,
            child: _ResultLine(
              text: result,
              fontSize: resultFontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayLine extends StatelessWidget {
  const _DisplayLine({
    required this.text,
    required this.emptyText,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.alignment,
  });

  final String text;
  final String emptyText;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final value = text.isEmpty ? emptyText : text;
    if (value.isEmpty) {
      return const SizedBox.expand();
    }

    return Align(
      alignment: alignment,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Text(
                value,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: color,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: constraints.maxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                text,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.mode,
    required this.angleMode,
    required this.hasMemory,
    required this.programmerBase,
  });

  final CalculatorMode mode;
  final AngleMode angleMode;
  final bool hasMemory;
  final ProgrammerBase programmerBase;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (mode == CalculatorMode.scientific) {
      chips.add(_StatusChip(label: angleMode.label));
    }
    if (mode == CalculatorMode.programmer) {
      chips.add(_StatusChip(label: programmerBase.label));
    }
    if (hasMemory) {
      chips.add(const _StatusChip(label: 'M'));
    }

    if (chips.isEmpty) {
      return const SizedBox(height: 20);
    }

    return SizedBox(
      height: 20,
      child: Row(
        children: [
          for (var index = 0; index < chips.length; index++) ...[
            if (index > 0) const SizedBox(width: 6),
            chips[index],
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
