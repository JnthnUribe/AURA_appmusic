import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

abstract final class AuraToast {
  static void show(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    final colors = context.auraColors;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          width: 320,
          content: Row(
            children: [
              Icon(icon, size: 18, color: colors.accent),
              const SizedBox(width: AuraSpace.xs),
              Expanded(
                child: Text(
                  message,
                  style: AuraType.footnote.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
