import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/animated_gradient_background.dart';
import '../../components/cover_art.dart';
import '../../components/pressable_scale.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/format.dart';
import '../../data/local/database.dart';
import '../media/media_providers.dart';
import 'player_controller.dart';
import 'queue_engine.dart';

class NowPlayingScreen extends ConsumerStatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  ConsumerState<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends ConsumerState<NowPlayingScreen> {
  double? _dragProgress;

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerControllerProvider);
    final track = player.current;
    final colors = context.auraColors;
    if (track == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text(
            context.l10n.queueEmpty,
            style: AuraType.body.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    final controller = ref.read(playerControllerProvider.notifier);
    final palette = ref
        .watch(coverInfoProvider(track.albumId))
        .value
        ?.palette
        ?.map(colorFromHex)
        .whereType<Color>()
        .toList(growable: false);
    final width = MediaQuery.sizeOf(context).width;
    final coverSize = math.min(width - 64, 380.0);
    final duration = player.duration.inMilliseconds > 0
        ? player.duration
        : (track.duration ?? Duration.zero);
    final progress = _dragProgress ?? player.progress;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 280) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: Stack(
          children: [
            AnimatedGradientBackground(
              colors: palette == null || palette.isEmpty
                  ? null
                  : [
                      palette.first,
                      palette.length > 1 ? palette[1] : palette.first,
                      colors.backgroundElevated,
                    ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AuraSpace.xl,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: context.l10n.close,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.nowPlaying.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AuraType.caption.copyWith(
                              color: colors.textSecondary,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showQueue(context, ref),
                          tooltip: context.l10n.queue,
                          icon: const Icon(Icons.queue_music_rounded),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    PressableScale(
                      onTap: controller.togglePlay,
                      haptic: false,
                      scale: 0.985,
                      child: AnimatedScale(
                        scale: player.playing ? 1 : 0.85,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutBack,
                        child: CoverArt(
                          albumId: track.albumId,
                          size: coverSize,
                          radius: AuraRadius.xl,
                          tintShadow: true,
                          heroTag: 'now-playing-cover',
                          placeholderSeed: track.albumTitle ?? track.title,
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        track.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AuraType.title1.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AuraSpace.xxs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        track.artistNames.isEmpty
                            ? context.l10n.unknownArtist
                            : track.artistNames,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AuraType.title3.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: AuraSpace.lg),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: _dragProgress == null ? 3 : 6,
                        activeTrackColor: colors.textPrimary,
                        inactiveTrackColor: colors.textPrimary.withValues(
                          alpha: 0.18,
                        ),
                        thumbColor: colors.textPrimary,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: Slider(
                        value: progress.clamp(0, 1),
                        onChangeStart: (value) {
                          setState(() => _dragProgress = value);
                        },
                        onChanged: (value) {
                          setState(() => _dragProgress = value);
                        },
                        onChangeEnd: (value) {
                          setState(() => _dragProgress = null);
                          controller.seek(
                            Duration(
                              milliseconds:
                                  (duration.inMilliseconds * value).round(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AuraSpace.xxs,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(
                              Duration(
                                milliseconds:
                                    (duration.inMilliseconds * progress).round(),
                              ),
                            ),
                            style: AuraType.caption.copyWith(
                              color: colors.textSecondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          Text(
                            formatDuration(duration),
                            style: AuraType.caption.copyWith(
                              color: colors.textSecondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AuraSpace.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ControlButton(
                          icon: Icons.shuffle_rounded,
                          active: player.shuffle,
                          onTap: controller.toggleShuffle,
                          semanticLabel: context.l10n.shuffle,
                        ),
                        _ControlButton(
                          icon: Icons.skip_previous_rounded,
                          size: 36,
                          onTap: controller.skipPrevious,
                          semanticLabel: context.l10n.previous,
                        ),
                        _PlayButton(
                          playing: player.playing,
                          loading: player.loading,
                          onTap: controller.togglePlay,
                          semanticLabel: player.playing
                              ? context.l10n.pause
                              : context.l10n.play,
                        ),
                        _ControlButton(
                          icon: Icons.skip_next_rounded,
                          size: 36,
                          onTap: controller.skipNext,
                          semanticLabel: context.l10n.next,
                        ),
                        _ControlButton(
                          icon: player.repeat == RepeatMode.one
                              ? Icons.repeat_one_rounded
                              : Icons.repeat_rounded,
                          active: player.repeat != RepeatMode.off,
                          onTap: controller.cycleRepeat,
                          semanticLabel: context.l10n.queue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AuraSpace.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FooterAction(
                          icon: Icons.lyrics_outlined,
                          label: context.l10n.lyrics,
                          onTap: () => context.push('/lyrics'),
                        ),
                        _FooterAction(
                          icon: Icons.queue_music_rounded,
                          label: context.l10n.queue,
                          onTap: () => _showQueue(context, ref),
                        ),
                        _FooterAction(
                          icon: Icons.bedtime_outlined,
                          label: context.l10n.sleepTimer,
                          onTap: () => _showSleepTimer(context, ref),
                        ),
                        _FooterAction(
                          icon: Icons.speed_rounded,
                          label: context.l10n.speed,
                          onTap: () => _showSpeed(context, ref),
                        ),
                      ],
                    ),
                    const SizedBox(height: AuraSpace.md),
                    if (player.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AuraSpace.xs),
                        child: Text(
                          player.error!,
                          textAlign: TextAlign.center,
                          style: AuraType.footnote.copyWith(
                            color: colors.danger,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQueue(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(playerControllerProvider.notifier);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final player = ref.watch(playerControllerProvider);
            final colors = context.auraColors;
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.66,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AuraSpace.md,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.queue,
                              style: AuraType.title2,
                            ),
                          ),
                          Text(
                            context.l10n.tracksCount(player.queue.length),
                            style: AuraType.footnote.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AuraSpace.xs),
                    Expanded(
                      child: player.queue.isEmpty
                          ? Center(
                              child: Text(
                                context.l10n.queueEmpty,
                                style: AuraType.body.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            )
                          : ReorderableListView.builder(
                              padding: const EdgeInsets.only(
                                bottom: AuraSpace.lg,
                              ),
                              itemCount: player.queue.length,
                              onReorder: controller.reorderQueue,
                              buildDefaultDragHandles: false,
                              itemBuilder: (context, index) {
                                final item = player.queue[index];
                                final isCurrent = index == player.index;
                                return ListTile(
                                  key: ValueKey('${item.id}-$index'),
                                  selected: isCurrent,
                                  selectedTileColor: colors.accentSoft,
                                  leading: Text(
                                    '${index + 1}',
                                    style: AuraType.caption.copyWith(
                                      color: isCurrent
                                          ? colors.accent
                                          : colors.textTertiary,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                  title: Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AuraType.callout.copyWith(
                                      color: isCurrent
                                          ? colors.accent
                                          : colors.textPrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.artistNames,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AuraType.caption.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  onTap: () => controller.jumpTo(index),
                                  trailing: ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(
                                      Icons.drag_handle_rounded,
                                      color: colors.textTertiary,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSleepTimer(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(playerControllerProvider.notifier);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  context.l10n.sleepTimer,
                  style: AuraType.title3,
                ),
              ),
              for (final minutes in [10, 20, 30, 45, 60])
                ListTile(
                  leading: const Icon(Icons.bedtime_outlined),
                  title: Text('$minutes min', style: AuraType.callout),
                  onTap: () {
                    controller.startSleepTimer(Duration(minutes: minutes));
                    Navigator.pop(sheetContext);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: Text(context.l10n.cancel, style: AuraType.callout),
                onTap: () {
                  controller.cancelSleepTimer();
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSpeed(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(playerControllerProvider.notifier);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n.speed, style: AuraType.title3),
              ),
              for (final speed in [0.75, 1.0, 1.25, 1.5, 1.75])
                ListTile(
                  leading: const Icon(Icons.speed_rounded),
                  title: Text('${speed}x', style: AuraType.callout),
                  onTap: () {
                    controller.setSpeed(speed);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.playing,
    required this.loading,
    required this.onTap,
    required this.semanticLabel,
  });

  final bool playing;
  final bool loading;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: PressableScale(
        onTap: onTap,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: colors.textPrimary,
            shape: BoxShape.circle,
          ),
          child: loading
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.background,
                  ),
                )
              : Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 40,
                  color: colors.background,
                ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.active = false,
    this.size = 24,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return IconButton(
      onPressed: onTap,
      tooltip: semanticLabel,
      icon: Icon(
        icon,
        size: size,
        color: active ? colors.accent : colors.textPrimary,
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AuraSpace.xs,
          vertical: AuraSpace.xxs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: colors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AuraType.caption.copyWith(
                color: colors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
