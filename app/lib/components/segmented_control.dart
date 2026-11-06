import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

class SegmentItem<T> {
  const SegmentItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// Animated segmented control with a sliding pill, like iOS.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final selectedIndex = items.indexWhere((item) => item.value == value);
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surfaceStrong,
        borderRadius: BorderRadius.circular(AuraRadius.sm),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / items.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: selectedIndex.clamp(0, items.length - 1) * width,
                top: 0,
                bottom: 0,
                width: width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(AuraRadius.sm),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (final item in items)
                    Expanded(
                      child: Semantics(
                        selected: item.value == value,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(item.value),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AuraType.footnote.copyWith(
                                color: item.value == value
                                    ? colors.textPrimary
                                    : colors.textSecondary,
                                fontWeight: item.value == value
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                              child: Text(item.label),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
