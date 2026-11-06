import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/cover_art.dart';
import '../../components/pressable_scale.dart';
import '../../components/section_header.dart';
import '../../components/track_tile.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import 'search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final state = ref.watch(searchControllerProvider);
    final notifier = ref.read(searchControllerProvider.notifier);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AuraSpace.md,
              AuraSpace.xs,
              AuraSpace.md,
              AuraSpace.sm,
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              textInputAction: TextInputAction.search,
              autocorrect: false,
              onChanged: notifier.setQuery,
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: state.query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _controller.clear();
                          notifier.clear();
                        },
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
              ),
            ),
          ),
          if (state.loading)
            const LinearProgressIndicator(minHeight: 2)
          else
            const SizedBox(height: 2),
          Expanded(
            child: state.query.isEmpty
                ? _Hint(colors: colors)
                : state.isEmpty
                ? _NoResults(query: state.query)
                : _Results(state: state),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.colors});

  final AuraColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, size: 48, color: colors.textTertiary),
          const SizedBox(height: AuraSpace.md),
          Text(
            context.l10n.searchEmpty,
            style: AuraType.title3.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AuraSpace.xs),
          Text(
            context.l10n.searchHint,
            style: AuraType.footnote.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AuraSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 44,
              color: colors.textTertiary,
            ),
            const SizedBox(height: AuraSpace.md),
            Text(
              context.l10n.searchNoResults(query),
              textAlign: TextAlign.center,
              style: AuraType.body.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final albums = state.remote?.albums ?? const [];
    final artists = state.remote?.artists ?? const [];
    final tracks = state.tracks;
    return ListView(
      padding: const EdgeInsets.only(bottom: 180),
      children: [
        if (tracks.isNotEmpty) ...[
          SectionHeader(title: context.l10n.songs),
          for (final track in tracks)
            TrackTile(track: track, queue: tracks, showAlbum: true),
        ],
        if (albums.isNotEmpty) ...[
          SectionHeader(title: context.l10n.albums),
          for (final album in albums)
            PressableScale(
              onTap: () => context.push('/album/${album.id}'),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AuraSpace.md,
                  vertical: AuraSpace.xs,
                ),
                child: Row(
                  children: [
                    CoverArt(
                      albumId: album.id,
                      size: 52,
                      radius: AuraRadius.sm,
                      placeholderSeed: album.title,
                    ),
                    const SizedBox(width: AuraSpace.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AuraType.body.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            album.albumArtist?.name ??
                                context.l10n.unknownArtist,
                            style: AuraType.footnote.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
        ],
        if (artists.isNotEmpty) ...[
          SectionHeader(title: context.l10n.artists),
          for (final artist in artists)
            PressableScale(
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
            ),
        ],
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.all(AuraSpace.md),
            child: Text(
              state.error!,
              textAlign: TextAlign.center,
              style: AuraType.caption.copyWith(color: colors.danger),
            ),
          ),
      ],
    );
  }
}
