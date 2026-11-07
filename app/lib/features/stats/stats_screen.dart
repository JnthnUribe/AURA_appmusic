import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/aura_scaffold.dart';
import '../../components/cover_art.dart';
import '../../components/glass_surface.dart';
import '../../components/segmented_control.dart';
import '../../components/skeleton.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import 'stats_controller.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final stats = ref.watch(statsOverviewProvider(_range));

    return AuraScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          context.l10n.statsTitle,
          style: AuraType.headline.copyWith(color: colors.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AuraSpace.md,
            AuraSpace.xs,
            AuraSpace.md,
            AuraSpace.huge,
          ),
          children: [
            SegmentedControl<String>(
              value: _range,
              onChanged: (value) => setState(() => _range = value),
              items: [
                SegmentItem(value: '7d', label: context.l10n.range7d),
                SegmentItem(value: '30d', label: context.l10n.range30d),
                SegmentItem(value: '90d', label: context.l10n.range90d),
                SegmentItem(value: 'all', label: context.l10n.rangeAll),
              ],
            ),
            const SizedBox(height: AuraSpace.lg),
            stats.when(
              loading: () => const _StatsSkeleton(),
              error: (error, _) => _StatsError(
                onRetry: () =>
                    ref.invalidate(statsOverviewProvider(_range)),
              ),
              data: (overview) => _StatsBody(overview: overview),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.overview});

  final StatsOverview overview;

  @override
  Widget build(BuildContext context) {
    if (overview.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AuraSpace.xxl),
        child: Center(
          child: Text(
            context.l10n.statsEmpty,
            textAlign: TextAlign.center,
            style: AuraType.body.copyWith(
              color: context.auraColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricGrid(overview: overview),
        const SizedBox(height: AuraSpace.xl),
        if (overview.topArtists.isNotEmpty) ...[
          _SectionLabel(context.l10n.topArtists),
          GlassSurface(
            borderRadius: BorderRadius.circular(AuraRadius.lg),
            child: Column(
              children: [
                for (var index = 0; index < overview.topArtists.length; index++)
                  _ArtistRow(
                    position: index + 1,
                    artist: overview.topArtists[index],
                    showDivider: index < overview.topArtists.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AuraSpace.xl),
        ],
        if (overview.topTracks.isNotEmpty) ...[
          _SectionLabel(context.l10n.topTracks),
          GlassSurface(
            borderRadius: BorderRadius.circular(AuraRadius.lg),
            child: Column(
              children: [
                for (var index = 0; index < overview.topTracks.length; index++)
                  _TrackRow(
                    position: index + 1,
                    track: overview.topTracks[index],
                    showDivider: index < overview.topTracks.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.overview});

  final StatsOverview overview;

  @override
  Widget build(BuildContext context) {
    final minutes = overview.minutes.round();
    final items = [
      (context.l10n.plays, '${overview.plays}', Icons.play_circle_outline_rounded),
      (context.l10n.minutes, formatMinutes(minutes), Icons.schedule_rounded),
      (
        context.l10n.uniqueTracks,
        '${overview.uniqueTracks}',
        Icons.music_note_rounded,
      ),
      (
        context.l10n.streakLabel,
        context.l10n.streak(overview.streakDays),
        Icons.local_fire_department_outlined,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AuraSpace.sm) / 2;
        return Wrap(
          spacing: AuraSpace.sm,
          runSpacing: AuraSpace.sm,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _MetricCard(
                  label: item.$1,
                  value: item.$2,
                  icon: item.$3,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Container(
      padding: const EdgeInsets.all(AuraSpace.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AuraRadius.lg),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.accent),
          const SizedBox(height: AuraSpace.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AuraType.title2.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AuraSpace.xxs),
          Text(
            label,
            maxLines: 2,
            style: AuraType.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ArtistRow extends StatelessWidget {
  const _ArtistRow({
    required this.position,
    required this.artist,
    required this.showDivider,
  });

  final int position;
  final TopArtist artist;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AuraSpace.md,
            vertical: AuraSpace.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '$position',
                  style: AuraType.caption.copyWith(color: colors.textTertiary),
                ),
              ),
              Expanded(
                child: Text(
                  artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AuraType.callout.copyWith(color: colors.textPrimary),
                ),
              ),
              Text(
                context.l10n.tracksCount(artist.plays),
                style: AuraType.caption.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: colors.divider, height: 1),
      ],
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.position,
    required this.track,
    required this.showDivider,
  });

  final int position;
  final Track track;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AuraSpace.md,
            vertical: AuraSpace.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '$position',
                  style: AuraType.caption.copyWith(color: colors.textTertiary),
                ),
              ),
              CoverArt(
                albumId: track.album?.id,
                size: 40,
                radius: AuraRadius.sm,
                placeholderSeed: track.album?.title ?? track.title,
              ),
              const SizedBox(width: AuraSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AuraType.callout.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      track.artistNames.isEmpty
                          ? context.l10n.unknownArtist
                          : track.artistNames,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AuraType.footnote.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: colors.divider, height: 1),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AuraSpace.xxs,
        bottom: AuraSpace.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: AuraType.caption.copyWith(
          color: context.auraColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: AuraSkeleton(height: 112)),
            SizedBox(width: AuraSpace.sm),
            Expanded(child: AuraSkeleton(height: 112)),
          ],
        ),
        const SizedBox(height: AuraSpace.sm),
        Row(
          children: const [
            Expanded(child: AuraSkeleton(height: 112)),
            SizedBox(width: AuraSpace.sm),
            Expanded(child: AuraSkeleton(height: 112)),
          ],
        ),
        const SizedBox(height: AuraSpace.xl),
        const AuraSkeleton(height: 220),
      ],
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Padding(
      padding: const EdgeInsets.only(top: AuraSpace.xxl),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 36, color: colors.textTertiary),
          const SizedBox(height: AuraSpace.sm),
          Text(
            context.l10n.connectionError,
            textAlign: TextAlign.center,
            style: AuraType.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AuraSpace.md),
          FilledButton(
            onPressed: onRetry,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
