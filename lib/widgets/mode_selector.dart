import 'package:flutter/material.dart';

import '../models/calculator_mode.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  final CalculatorMode selectedMode;
  final ValueChanged<CalculatorMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: CalculatorMode.values.map((mode) {
          final selected = mode == selectedMode;
          return Expanded(
            child: Material(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onChanged(mode),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        mode.label,
                        maxLines: 1,
                        softWrap: false,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: selected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
