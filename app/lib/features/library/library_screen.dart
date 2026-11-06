import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/cover_art.dart';
import '../../components/pressable_scale.dart';
import '../../components/segmented_control.dart';
import '../../components/skeleton.dart';
import '../../components/track_tile.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../data/local/database.dart';
import 'library_providers.dart';

enum _LibraryTab { songs, albums, artists }

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  _LibraryTab _tab = _LibraryTab.songs;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(syncControllerProvider.notifier).syncIfStale();
    });
  }

  Future<void> _refresh() async {
    await ref.read(syncControllerProvider.notifier).sync();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final tracks = ref.watch(tracksProvider);
    final albums = ref.watch(albumsProvider);
    final artists = ref.watch(artistsProvider);
    final sync = ref.watch(syncControllerProvider);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            context.l10n.libraryTitle,
            style: AuraType.largeTitle.copyWith(color: colors.textPrimary),
          ),
          backgroundColor: colors.background.withValues(alpha: 0.72),
          border: null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sync.syncing)
                const Padding(
                  padding: EdgeInsets.only(right: AuraSpace.xs),
                  child: CupertinoActivityIndicator(radius: 8),
                )
              else
                IconButton(
                  onPressed: _refresh,
                  tooltip: context.l10n.refresh,
                  icon: const Icon(Icons.sync_rounded, size: 21),
                ),
            ],
          ),
        ),
        CupertinoSliverRefreshControl(onRefresh: _refresh),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AuraSpace.md,
              AuraSpace.xs,
              AuraSpace.md,
              AuraSpace.sm,
            ),
            child: SegmentedControl<_LibraryTab>(
              value: _tab,
              onChanged: (value) => setState(() => _tab = value),
              items: [
                SegmentItem(value: _LibraryTab.songs, label: context.l10n.songs),
                SegmentItem(
                  value: _LibraryTab.albums,
                  label: context.l10n.albums,
                ),
                SegmentItem(
                  value: _LibraryTab.artists,
                  label: context.l10n.artists,
                ),
              ],
            ),
          ),
        ),
        if (sync.error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AuraSpace.md),
              child: Container(
                padding: const EdgeInsets.all(AuraSpace.sm),
                decoration: BoxDecoration(
                  color: colors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AuraRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 18,
                      color: colors.danger,
                    ),
                    const SizedBox(width: AuraSpace.xs),
                    Expanded(
                      child: Text(
                        sync.error!,
                        style: AuraType.footnote.copyWith(color: colors.danger),
                      ),
                    ),
                    TextButton(
                      onPressed: _refresh,
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ...(switch (_tab) {
          _LibraryTab.songs => _songSlivers(tracks),
          _LibraryTab.albums => _albumSlivers(albums),
          _LibraryTab.artists => _artistSlivers(artists),
        }),
        const SliverToBoxAdapter(
          child: SizedBox(height: 170),
        ),
      ],
    );
  }

  List<Widget> _songSlivers(AsyncValue<List<LocalTrack>> tracks) {
    final colors = context.auraColors;
    return tracks.when(
      loading: () => [
        SliverList.builder(
          itemCount: 8,
          itemBuilder: (context, index) => const TrackTileSkeleton(),
        ),
      ],
      error: (error, _) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: Icons.cloud_off_rounded,
            title: context.l10n.connectionError,
            subtitle: error.toString(),
          ),
        ),
      ],
      data: (items) {
        if (items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                icon: Icons.library_music_outlined,
                title: context.l10n.emptyLibrary,
                subtitle: context.l10n.emptyLibraryHint,
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.only(top: AuraSpace.xxs),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final track = items[index];
                return TrackTile(
                  track: track,
                  queue: items,
                  showAlbum: true,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AuraSpace.md),
              child: Text(
                context.l10n.tracksCount(items.length),
                textAlign: TextAlign.center,
                style: AuraType.caption.copyWith(color: colors.textTertiary),
              ),
            ),
          ),
        ];
      },
    );
  }

  List<Widget> _albumSlivers(AsyncValue<List<LocalAlbum>> albums) {
    final colors = context.auraColors;
    return albums.when(
      loading: () => [
        SliverPadding(
          padding: const EdgeInsets.all(AuraSpace.md),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AuraSpace.md,
              crossAxisSpacing: AuraSpace.sm,
              childAspectRatio: 0.78,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AuraSkeleton(radius: AuraRadius.md)),
                SizedBox(height: AuraSpace.xs),
                AuraSkeleton(height: 12, width: 110),
              ],
            ),
          ),
        ),
      ],
      error: (_, _) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: Icons.album_outlined,
            title: context.l10n.emptyLibrary,
            subtitle: context.l10n.emptyLibraryHint,
          ),
        ),
      ],
      data: (items) {
        if (items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                icon: Icons.album_outlined,
                title: context.l10n.emptyLibrary,
                subtitle: context.l10n.emptyLibraryHint,
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AuraSpace.md,
              AuraSpace.xs,
              AuraSpace.md,
              0,
            ),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AuraSpace.lg,
                crossAxisSpacing: AuraSpace.sm,
                childAspectRatio: 0.76,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final album = items[index];
                return PressableScale(
                  onTap: () => context.push('/album/${album.id}'),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CoverArt(
                            albumId: album.id,
                            size: constraints.maxWidth,
                            radius: AuraRadius.md,
                            placeholderSeed: album.albumArtistName ?? album.title,
                          ),
                          const SizedBox(height: AuraSpace.xs),
                          Text(
                            album.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AuraType.subhead.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            album.albumArtistName ??
                                context.l10n.unknownArtist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AuraType.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  List<Widget> _artistSlivers(AsyncValue<List<LocalArtist>> artists) {
    final colors = context.auraColors;
    return artists.when(
      loading: () => [
        SliverList.builder(
          itemCount: 6,
          itemBuilder: (context, index) => const TrackTileSkeleton(),
        ),
      ],
      error: (_, _) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: Icons.people_outline_rounded,
            title: context.l10n.emptyLibrary,
            subtitle: context.l10n.emptyLibraryHint,
          ),
        ),
      ],
      data: (items) {
        if (items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                icon: Icons.people_outline_rounded,
                title: context.l10n.emptyLibrary,
                subtitle: context.l10n.emptyLibraryHint,
              ),
            ),
          ];
        }
        return [
          SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final artist = items[index];
              return PressableScale(
                onTap: () => context.push('/artist/${artist.id}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AuraSpace.md,
                    vertical: AuraSpace.xs,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colors.surfaceStrong,
                        child: Text(
                          initials(artist.name),
                          style: AuraType.callout.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AuraSpace.sm),
                      Expanded(
                        child: Text(
                          artist.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AuraType.body.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ];
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AuraSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.textTertiary),
            const SizedBox(height: AuraSpace.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AuraType.title3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AuraSpace.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AuraType.footnote.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
