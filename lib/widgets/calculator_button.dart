import 'package:flutter/material.dart';

enum CalculatorButtonKind {
  standard,
  operator,
  function,
  base,
}

class CalculatorButton extends StatefulWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.kind = CalculatorButtonKind.standard,
    this.tooltip,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final CalculatorButtonKind kind;
  final String? tooltip;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _ButtonStyle.from(theme, widget.kind, widget.selected);
    final disabledBackground =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.28);
    final disabledForeground =
        theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.38);
    final disabledBorder =
        theme.colorScheme.outlineVariant.withValues(alpha: 0.45);
    final borderColor = widget.enabled ? style.border : disabledBorder;
    final shadow = widget.enabled && widget.selected
        ? [
            BoxShadow(
              color: style.background.withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
        : null;

    final button = AnimatedScale(
      scale: _pressed && widget.enabled ? 0.94 : 1,
      duration: const Duration(milliseconds: 90),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: widget.selected ? 1.6 : 1,
          ),
          boxShadow: shadow,
        ),
        child: Material(
          color: widget.enabled ? style.background : disabledBackground,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.enabled ? widget.onPressed : null,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            splashFactory:
                widget.enabled ? InkRipple.splashFactory : NoSplash.splashFactory,
            onTapDown:
                widget.enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp:
                widget.enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel:
                widget.enabled ? () => setState(() => _pressed = false) : null,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 42;
                final longLabel = widget.label.length > 2;
                final fontSize = longLabel
                    ? (compact ? 11.0 : 12.5)
                    : (compact ? 14.0 : 16.0);
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        softWrap: false,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color:
                              widget.enabled ? style.foreground : disabledForeground,
                          fontSize: fontSize,
                          fontWeight:
                              widget.selected ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      label: widget.tooltip ?? widget.label,
      child: widget.tooltip == null ? button : Tooltip(message: widget.tooltip!, child: button),
    );
  }
}

class _ButtonStyle {
  const _ButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;

  factory _ButtonStyle.from(
    ThemeData theme,
    CalculatorButtonKind kind,
    bool selected,
  ) {
    final scheme = theme.colorScheme;
    if (selected) {
      return _ButtonStyle(
        background: scheme.tertiary,
        foreground: scheme.onTertiary,
        border: scheme.primary,
      );
    }

    switch (kind) {
      case CalculatorButtonKind.operator:
        return _ButtonStyle(
          background: scheme.primary,
          foreground: scheme.onPrimary,
          border: scheme.primary.withValues(alpha: 0.7),
        );
      case CalculatorButtonKind.function:
        return _ButtonStyle(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          border: scheme.outlineVariant.withValues(alpha: 0.8),
        );
      case CalculatorButtonKind.base:
        return _ButtonStyle(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurfaceVariant,
          border: scheme.outlineVariant,
        );
      case CalculatorButtonKind.standard:
        return _ButtonStyle(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurface,
          border: scheme.outlineVariant.withValues(alpha: 0.65),
        );
    }
  }
}
