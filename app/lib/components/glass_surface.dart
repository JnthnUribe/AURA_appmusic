import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

/// Frosted glass. Keep at most two visible at once (tab bar + mini player).
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.blur = 22,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AuraRadius.xl),
    ),
    this.tint,
    this.border = true,
    this.padding,
  });

  final Widget child;
  final double blur;
  final BorderRadius borderRadius;
  final Color? tint;
  final bool border;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final media = MediaQuery.maybeOf(context);
    final reduceTransparency = media?.disableAnimations ?? false;
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: reduceTransparency ? 0 : blur,
            sigmaY: reduceTransparency ? 0 : blur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tint ?? colors.glassTint,
              borderRadius: borderRadius,
              border: border
                  ? Border.all(color: colors.glassBorder, width: 1)
                  : null,
            ),
            child: padding == null
                ? child
                : Padding(padding: padding!, child: child),
          ),
        ),
      ),
    );
  }
}
