import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/design/motion.dart';
import '../core/design/tokens.dart';

/// Three blurred palette blobs behind the content. Pauses with reduce motion.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    this.colors,
    this.intensity = 1,
  });

  final List<Color>? colors;
  final double intensity;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AuraMotion.reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final palette =
        widget.colors ??
        [colors.accent, const Color(0xFF9B7CFF), const Color(0xFF3ED6C0)];
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.background,
                      colors.backgroundElevated,
                      colors.background,
                    ],
                  ),
                ),
              ),
              _blob(
                palette[0],
                Alignment(-0.9 + 0.4 * t, -0.9 + 0.2 * t),
                0.9,
              ),
              _blob(
                palette[1],
                Alignment(0.9 - 0.3 * t, -0.3 - 0.2 * t),
                0.75,
              ),
              _blob(
                palette[2],
                Alignment(-0.4 + 0.2 * t, 1.05 - 0.25 * t),
                0.8,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob(Color color, Alignment alignment, double sizeFactor) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: sizeFactor,
        heightFactor: 0.45,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.16 * widget.intensity),
            ),
          ),
        ),
      ),
    );
  }
}
