import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/cover_art.dart';
import '../../components/track_tile.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../data/local/database.dart';
import '../player/player_controller.dart';
import 'library_providers.dart';

class AlbumScreen extends ConsumerWidget {
  const AlbumScreen({super.key, required this.albumId});

  final String albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.auraColors;
    final album = ref.watch(albumProvider(albumId)).value;
    final tracks = ref.watch(albumTracksProvider(albumId)).value ?? const [];
    final coverSize = 220.0;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 340,
            backgroundColor: colors.background.withValues(alpha: 0.92),
            surfaceTintColor: Colors.transparent,
            leading: const BackButton(),
            title: Text(
              album?.title ?? '',
              style: AuraType.headline.copyWith(color: colors.textPrimary),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      CoverArt(
                        albumId: albumId,
                        size: coverSize,
                        radius: AuraRadius.lg,
                        tintShadow: true,
                        placeholderSeed: album?.albumArtistName ?? album?.title,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AuraSpace.md,
                AuraSpace.xs,
                AuraSpace.md,
                AuraSpace.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album?.title ?? context.l10n.unknownAlbum,
                    style: AuraType.title1.copyWith(color: colors.textPrimary),
                  ),
                  const SizedBox(height: AuraSpace.xxs),
                  Text(
                    [
                      album?.albumArtistName ?? context.l10n.unknownArtist,
                      if (album?.year != null) '${album!.year}',
                      if (tracks.isNotEmpty)
                        context.l10n.tracksCount(tracks.length),
                    ].join(' · '),
                    style: AuraType.footnote.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AuraSpace.md),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: tracks.isEmpty
                              ? null
                              : () => ref
                                    .read(playerControllerProvider.notifier)
                                    .playQueue(tracks),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(context.l10n.play),
                        ),
                      ),
                      const SizedBox(width: AuraSpace.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: tracks.isEmpty
                              ? null
                              : () => ref
                                    .read(playerControllerProvider.notifier)
                                    .playQueue(tracks, shuffle: true),
                          icon: const Icon(Icons.shuffle_rounded),
                          label: Text(context.l10n.shuffle),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(64, 52),
                            foregroundColor: colors.textPrimary,
                            side: BorderSide(color: colors.divider),
                            shape: const RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(AuraRadius.md),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (tracks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  context.l10n.emptyLibrary,
                  style: AuraType.body.copyWith(color: colors.textSecondary),
                ),
              ),
            )
          else
            SliverList.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return TrackTile(
                  track: track,
                  queue: tracks,
                  showCover: false,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (track.duration != null)
                        Text(
                          formatDuration(track.duration),
                          style: AuraType.caption.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .playTrack(track, queueOf: tracks),
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 150)),
        ],
      ),
    );
  }
}
