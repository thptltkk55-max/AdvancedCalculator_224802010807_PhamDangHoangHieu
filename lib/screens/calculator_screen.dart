import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/button_grid.dart';
import '../widgets/display_area.dart';
import '../widgets/mode_selector.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calculator, _) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 44,
            title: const Text('Advanced Calculator'),
            titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            actions: [
              IconButton(
                tooltip: 'History',
                icon: const Icon(Icons.history),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HistoryScreen(),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactHeight = constraints.maxHeight < 690;
                final pagePadding = compactHeight ? 8.0 : 10.0;
                final gap = compactHeight ? 6.0 : 8.0;
                final displayHeight = switch (calculator.mode) {
                  CalculatorMode.basic => compactHeight ? 118.0 : 132.0,
                  CalculatorMode.scientific => compactHeight ? 106.0 : 120.0,
                  CalculatorMode.programmer => compactHeight ? 96.0 : 108.0,
                };

                return Padding(
                  padding: EdgeInsets.all(pagePadding),
                  child: Column(
                    children: [
                      ModeSelector(
                        selectedMode: calculator.mode,
                        onChanged: calculator.toggleMode,
                      ),
                      SizedBox(height: gap),
                      SizedBox(
                        height: displayHeight,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if ((details.primaryVelocity ?? 0) > 0) {
                              calculator.deleteLast();
                            }
                          },
                          onVerticalDragEnd: (details) {
                            if ((details.primaryVelocity ?? 0) < 0) {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HistoryScreen(),
                                ),
                              );
                            }
                          },
                          child: DisplayArea(
                            expression: calculator.expression,
                            result: calculator.result,
                            angleMode: calculator.angleMode,
                            hasMemory: calculator.hasMemory,
                            mode: calculator.mode,
                            programmerBase: calculator.programmerBase,
                          ),
                        ),
                      ),
                      if (calculator.mode == CalculatorMode.programmer) ...[
                        SizedBox(height: gap),
                        const _ProgrammerBasePanel(),
                      ],
                      SizedBox(height: gap),
                      Expanded(
                        child: ButtonGrid(
                          onPressed: (label) => _handleButton(context, label),
                          onLongPress: (label) =>
                              _handleLongPress(context, label),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleButton(BuildContext context, String label) {
    final calculator = context.read<CalculatorProvider>();
    calculator.addToExpression(label);
    final historyItem = calculator.consumeLastCalculation();
    if (historyItem != null) {
      context.read<HistoryProvider>().addHistory(historyItem);
    }
  }

  Future<void> _handleLongPress(BuildContext context, String label) async {
    if (label != 'C' && label != 'CLR') {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoa lich su?'),
        content: const Text('Tat ca phep tinh da luu se bi xoa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xoa'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryProvider>().clearHistory();
    }
  }
}

class _ProgrammerBasePanel extends StatelessWidget {
  const _ProgrammerBasePanel();

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorProvider>();
    final values = calculator.programmerBaseValues();
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: values.entries
            .map(
              (entry) => SizedBox(
                height: 20,
                child: Row(
                  children: [
                    SizedBox(
                      width: 38,
                      child: Text(
                        entry.key.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
