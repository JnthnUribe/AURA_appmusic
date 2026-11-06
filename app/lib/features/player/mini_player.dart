import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/cover_art.dart';
import '../../components/glass_surface.dart';
import '../../components/pressable_scale.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../player/player_controller.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key, this.bottomInset = 0});

  final double bottomInset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerControllerProvider);
    final track = player.current;
    if (track == null) return const SizedBox.shrink();
    final colors = context.auraColors;
    final controller = ref.read(playerControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AuraSpace.sm,
        AuraSpace.xxs,
        AuraSpace.sm,
        bottomInset + AuraSpace.xxs,
      ),
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -250) {
            context.push('/player');
          }
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity < -350) {
            controller.skipNext();
          } else if (velocity > 350) {
            controller.skipPrevious();
          }
        },
        child: GlassSurface(
          borderRadius: BorderRadius.circular(AuraRadius.lg),
          child: PressableScale(
            onTap: () => context.push('/player'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      CoverArt(
                        albumId: track.albumId,
                        size: 44,
                        radius: AuraRadius.sm,
                        placeholderSeed: track.albumTitle ?? track.title,
                      ),
                      const SizedBox(width: AuraSpace.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AuraType.subhead.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              track.artistNames,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AuraType.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: controller.togglePlay,
                        tooltip: player.playing
                            ? context.l10n.pause
                            : context.l10n.play,
                        icon: Icon(
                          player.playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 28,
                          color: colors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: controller.skipNext,
                        tooltip: context.l10n.next,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          size: 26,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AuraRadius.lg),
                  ),
                  child: LinearProgressIndicator(
                    value: player.progress,
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    color: colors.accent.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
