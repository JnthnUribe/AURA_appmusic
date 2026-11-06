import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/track_tile.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../player/player_controller.dart';
import 'library_providers.dart';

class ArtistScreen extends ConsumerWidget {
  const ArtistScreen({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.auraColors;
    final artist = ref.watch(artistProvider(artistId)).value;
    final tracks =
        ref.watch(artistTracksProvider(artistId)).value ?? const [];

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: colors.background.withValues(alpha: 0.92),
            surfaceTintColor: Colors.transparent,
            leading: const BackButton(),
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colors.surfaceStrong,
                        child: Text(
                          initials(artist?.name ?? '?'),
                          style: AuraType.title2.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AuraSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artist?.name ?? context.l10n.unknownArtist,
                              style: AuraType.title1.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AuraSpace.xxs),
                            Text(
                              context.l10n.tracksCount(tracks.length),
                              style: AuraType.footnote.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AuraSpace.lg),
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
                return TrackTile(track: track, queue: tracks, showAlbum: true);
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 150)),
        ],
      ),
    );
  }
}
