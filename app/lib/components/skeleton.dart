import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

class AuraSkeleton extends StatefulWidget {
  const AuraSkeleton({
    super.key,
    this.height = 16,
    this.width,
    this.radius = AuraRadius.sm,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<AuraSkeleton> createState() => _AuraSkeletonState();
}

class _AuraSkeletonState extends State<AuraSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final offset = _controller.value * 2 - 1;
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + offset, 0),
              end: Alignment(1 + offset, 0),
              colors: [
                colors.surface,
                colors.surfaceStrong,
                colors.surface,
              ],
            ),
          ),
        );
      },
    );
  }
}

class TrackTileSkeleton extends StatelessWidget {
  const TrackTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AuraSpace.md,
        vertical: AuraSpace.xs,
      ),
      child: Row(
        children: [
          AuraSkeleton(height: 52, width: 52, radius: AuraRadius.sm),
          SizedBox(width: AuraSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuraSkeleton(height: 14, width: 180),
                SizedBox(height: AuraSpace.xs),
                AuraSkeleton(height: 12, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
