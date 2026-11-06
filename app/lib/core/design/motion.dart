import 'package:flutter/material.dart';

/// Centralized motion so every interaction feels like the same app.
abstract final class AuraMotion {
  static const quick = Duration(milliseconds: 200);
  static const standard = Duration(milliseconds: 280);
  static const expressive = Duration(milliseconds: 350);
  static const cover = Duration(milliseconds: 800);

  static const standardCurve = Curves.easeOutCubic;
  static const emphasizedCurve = Cubic(0.22, 1, 0.36, 1);
  static const spring = SpringDescription(
    mass: 1,
    stiffness: 320,
    damping: 26,
  );

  static bool reduceMotion(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    return media?.disableAnimations ?? false;
  }

  static Duration scaled(BuildContext context, Duration duration) {
    return reduceMotion(context) ? Duration.zero : duration;
  }
}
