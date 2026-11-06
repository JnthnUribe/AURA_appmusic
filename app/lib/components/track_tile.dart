import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design/tokens.dart';
import '../core/l10n/l10n.dart';
import '../core/network/api_exception.dart';
import '../core/providers.dart';
import '../core/utils/format.dart';
import '../data/local/database.dart';
import '../features/player/player_controller.dart';
import 'cover_art.dart';
import 'pressable_scale.dart';
import 'toast.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.track,
    required this.queue,
    this.onTap,
    this.onLongPress,
    this.showCover = true,
    this.showFavorite = true,
    this.showAlbum = false,
    this.trailing,
    this.dense = false,
  });

  final LocalTrack track;
  final List<LocalTrack> queue;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showCover;
  final bool showFavorite;
  final bool showAlbum;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.auraColors;
    final subtitle = showAlbum && track.albumTitle != null
        ? '${track.artistNames} · ${track.albumTitle}'
        : track.artistNames;
    return PressableScale(
      onTap: onTap ?? () => _play(ref),
      onLongPress: onLongPress ?? () => _showActions(context, ref),
      semanticLabel: '${track.title}, ${track.artistNames}',
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AuraSpace.md,
          vertical: dense ? AuraSpace.xxs : AuraSpace.xs,
        ),
        child: Row(
          children: [
            if (showCover) ...[
              CoverArt(
                albumId: track.albumId,
                size: dense ? 44 : 52,
                radius: AuraRadius.sm,
                placeholderSeed: track.albumTitle ?? track.title,
              ),
              const SizedBox(width: AuraSpace.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AuraType.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (track.explicit) ...[
                        const SizedBox(width: AuraSpace.xxs),
                        _ExplicitBadge(colors: colors),
                      ],
                    ],
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AuraType.footnote.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AuraSpace.xs),
            if (trailing != null)
              trailing!
            else ...[
              if (track.duration != null)
                Text(
                  formatDuration(track.duration),
                  style: AuraType.caption.copyWith(
                    color: colors.textTertiary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              if (showFavorite)
                IconButton(
                  onPressed: () => _toggleFavorite(context, ref),
                  tooltip: track.favorite
                      ? context.l10n.removeFromFavorites
                      : context.l10n.addToFavorites,
                  icon: Icon(
                    track.favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 19,
                    color: track.favorite
                        ? colors.accent
                        : colors.textTertiary,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _play(WidgetRef ref) async {
    await ref
        .read(playerControllerProvider.notifier)
        .playTrack(track, queueOf: queue);
  }

  Future<void> _toggleFavorite(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(libraryRepositoryProvider)
          .setFavorite(track.id, !track.favorite);
      if (context.mounted) {
        AuraToast.show(
          context,
          track.favorite
              ? context.l10n.removeFromFavorites
              : context.l10n.addToFavorites,
          icon: Icons.favorite_rounded,
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      AuraToast.show(
        context,
        error is ApiException ? error.userMessage : 'Error',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final colors = context.auraColors;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CoverArt(
                  albumId: track.albumId,
                  size: 48,
                  placeholderSeed: track.albumTitle ?? track.title,
                ),
                title: Text(track.title, style: AuraType.headline),
                subtitle: Text(
                  track.artistNames,
                  style: AuraType.footnote.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const Divider(),
              _action(
                sheetContext,
                icon: Icons.play_arrow_rounded,
                label: context.l10n.play,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _play(ref);
                },
              ),
              _action(
                sheetContext,
                icon: Icons.queue_music_rounded,
                label: context.l10n.addToQueue,
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref
                      .read(playerControllerProvider.notifier)
                      .addToQueue(track);
                },
              ),
              _action(
                sheetContext,
                icon: track.favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: track.favorite
                    ? context.l10n.removeFromFavorites
                    : context.l10n.addToFavorites,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _toggleFavorite(context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _action(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(label, style: AuraType.callout),
      onTap: onTap,
    );
  }
}

class _ExplicitBadge extends StatelessWidget {
  const _ExplicitBadge({required this.colors});

  final AuraColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: colors.surfaceStrong,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'E',
        style: AuraType.caption.copyWith(
          fontSize: 9,
          color: colors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
