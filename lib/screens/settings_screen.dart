import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/calculator_mode.dart';
import '../models/calculator_settings.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final settings = calculator.settings;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: const Text('Settings'),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 620;
            final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + 10;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                12,
                compact ? 8 : 10,
                12,
                bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Section(
                    title: 'Theme',
                    compact: compact,
                    child: _CompactSegmented<ThemeMode>(
                      values: ThemeMode.values,
                      selected: themeProvider.themeMode,
                      labelBuilder: (mode) => switch (mode) {
                        ThemeMode.light => 'Light',
                        ThemeMode.dark => 'Dark',
                        ThemeMode.system => 'System',
                      },
                      onChanged: (mode) async {
                        await themeProvider.setThemeMode(mode);
                        if (context.mounted) {
                          await context.read<CalculatorProvider>().updateSettings(
                                settings.copyWith(themeMode: mode),
                              );
                        }
                      },
                    ),
                  ),
                  _Section(
                    title: 'Decimal Precision',
                    trailing: settings.decimalPrecision.toString(),
                    compact: compact,
                    child: SizedBox(
                      height: compact ? 30 : 34,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          min: 2,
                          max: 10,
                          divisions: 8,
                          value: settings.decimalPrecision.toDouble(),
                          label: settings.decimalPrecision.toString(),
                          onChanged: (value) {
                            _save(
                              context,
                              settings.copyWith(
                                decimalPrecision: value.round(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  _Section(
                    title: 'Angle Mode',
                    compact: compact,
                    child: _CompactSegmented<AngleMode>(
                      values: AngleMode.values,
                      selected: settings.angleMode,
                      labelBuilder: (mode) => switch (mode) {
                        AngleMode.degrees => 'Degrees',
                        AngleMode.radians => 'Radians',
                      },
                      onChanged: (mode) {
                        _save(context, settings.copyWith(angleMode: mode));
                      },
                    ),
                  ),
                  _CompactSwitchRow(
                    title: 'Haptic Feedback',
                    value: settings.hapticFeedback,
                    compact: compact,
                    onChanged: (value) {
                      _save(context, settings.copyWith(hapticFeedback: value));
                    },
                  ),
                  _CompactSwitchRow(
                    title: 'Sound Effects',
                    value: settings.soundEffects,
                    compact: compact,
                    onChanged: (value) {
                      _save(context, settings.copyWith(soundEffects: value));
                    },
                  ),
                  SizedBox(height: compact ? 8 : 10),
                  _Section(
                    title: 'History Size',
                    compact: compact,
                    child: _CompactSegmented<int>(
                      values: const [25, 50, 100],
                      selected: settings.historySize,
                      labelBuilder: (value) => value.toString(),
                      onChanged: (size) {
                        context.read<HistoryProvider>().setMaxItems(size);
                        _save(context, settings.copyWith(historySize: size));
                      },
                    ),
                  ),
                  SizedBox(height: compact ? 2 : 4),
                  SizedBox(
                    height: compact ? 38 : 42,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Clear All History'),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () => _confirmClearHistory(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _save(BuildContext context, CalculatorSettings settings) {
    context.read<CalculatorProvider>().updateSettings(settings);
  }

  Future<void> _confirmClearHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear all history?'),
        content: const Text('Tat ca phep tinh da luu se bi xoa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryProvider>().clearHistory();
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    required this.compact,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final bool compact;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 10 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: compact ? 5 : 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _CompactSegmented<T> extends StatelessWidget {
  const _CompactSegmented({
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;

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
        children: values.map((value) {
          final isSelected = value == selected;
          return Expanded(
            child: Material(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onChanged(value),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        labelBuilder(value),
                        maxLines: 1,
                        softWrap: false,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
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

class _CompactSwitchRow extends StatelessWidget {
  const _CompactSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.compact,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: SizedBox(
        height: compact ? 40 : 44,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Transform.scale(
              scale: compact ? 0.82 : 0.88,
              child: Switch(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
