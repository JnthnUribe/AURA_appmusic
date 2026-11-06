import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

/// Section title with an optional trailing action, used by shelves and lists.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AuraSpace.md,
        AuraSpace.lg,
        AuraSpace.sm,
        AuraSpace.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AuraType.title3.copyWith(color: colors.textPrimary),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
