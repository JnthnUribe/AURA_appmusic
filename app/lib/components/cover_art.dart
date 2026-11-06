import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design/motion.dart';
import '../core/design/tokens.dart';
import '../features/media/media_providers.dart';

/// Album art with a palette-derived gradient placeholder, thumbhash preview,
/// Hero support and a tinted shadow.
class CoverArt extends ConsumerWidget {
  const CoverArt({
    super.key,
    required this.albumId,
    required this.size,
    this.radius = AuraRadius.md,
    this.heroTag,
    this.tintShadow = false,
    this.placeholderSeed,
  });

  final String? albumId;
  final double size;
  final double radius;
  final Object? heroTag;
  final bool tintShadow;
  final String? placeholderSeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = ref.watch(coverInfoProvider(albumId));
    final colors = context.auraColors;
    final paletteColor = _paletteColor(cover.value?.palette) ??
        _seedColor(placeholderSeed ?? albumId ?? 'aura');
    final thumbBytes = _decodeThumbhash(cover.value?.thumbhash);

    Widget art = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    paletteColor.withValues(alpha: 0.85),
                    Color.lerp(paletteColor, colors.background, 0.55)!,
                    colors.surface,
                  ],
                ),
              ),
            ),
            if (thumbBytes != null)
              Image.memory(
                thumbBytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                excludeFromSemantics: true,
              ),
            if (cover.value?.url != null)
              Image.network(
                cover.value!.url,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                frameBuilder: (context, child, frame, sync) {
                  if (sync || frame != null) {
                    return AnimatedOpacity(
                      opacity: 1,
                      duration: AuraMotion.scaled(context, AuraMotion.cover),
                      child: child,
                    );
                  }
                  return const SizedBox.shrink();
                },
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                excludeFromSemantics: true,
              ),
            if (cover.value?.url == null)
              Center(
                child: Icon(
                  Icons.graphic_eq_rounded,
                  size: size * 0.3,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
      ),
    );

    if (heroTag != null) {
      art = Hero(tag: heroTag!, child: art);
    }

    if (tintShadow) {
      art = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: paletteColor.withValues(alpha: 0.35),
              blurRadius: size * 0.22,
              spreadRadius: size * 0.01,
              offset: Offset(0, size * 0.08),
            ),
          ],
        ),
        child: art,
      );
    }
    return art;
  }

  static Color? _paletteColor(List<String>? palette) {
    if (palette == null || palette.isEmpty) return null;
    final value = palette.first.replaceFirst('#', '');
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(0xFF000000 | parsed);
  }

  static Color _seedColor(String seed) {
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return HSLColor.fromAHSL(1, (hash % 360).toDouble(), 0.42, 0.45).toColor();
  }

  static Uint8List? _decodeThumbhash(String? thumbhash) {
    if (thumbhash == null || !thumbhash.startsWith('data:image')) return null;
    final comma = thumbhash.indexOf(',');
    if (comma < 0) return null;
    try {
      return base64Decode(thumbhash.substring(comma + 1));
    } on FormatException {
      return null;
    }
  }
}
