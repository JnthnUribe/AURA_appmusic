import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../components/pressable_scale.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/providers.dart';
import '../media/media_providers.dart';
import '../player/player_controller.dart';
import 'lrc_utils.dart';

class LyricsScreen extends ConsumerStatefulWidget {
  const LyricsScreen({super.key});

  @override
  ConsumerState<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends ConsumerState<LyricsScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  int _lastActive = -1;
  bool _following = true;

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerControllerProvider);
    final track = player.current;
    final colors = context.auraColors;
    if (track == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(),
        body: Center(
          child: Text(
            context.l10n.queueEmpty,
            style: AuraType.body.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    final lyrics = ref.watch(lyricsProvider(track.id));
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.lyrics,
              style: AuraType.headline,
            ),
            Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AuraType.caption.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.refresh,
            onPressed: () => ref.invalidate(lyricsProvider(track.id)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: lyrics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _EmptyLyrics(onRetry: () => ref.invalidate(lyricsProvider(track.id))),
        data: (document) {
          if (document == null) {
            return _EmptyLyrics(
              onRetry: () => ref.invalidate(lyricsProvider(track.id)),
            );
          }
          final lines = document.isSynced
              ? shiftedLines(document.lines, document.offsetMs)
              : plainLines(document.plainText);
          final active = document.isSynced
              ? activeLyricIndex(lines, player.position)
              : -1;
          if (active != _lastActive) {
            _lastActive = active;
            if (_following && active >= 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_scrollController.isAttached) return;
                _scrollController.scrollTo(
                  index: active,
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  alignment: 0.42,
                );
              });
            }
          }
          return Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is UserScrollNotification) {
                      _following = notification.direction == ScrollDirection.idle;
                    }
                    return false;
                  },
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AuraSpace.lg,
                      AuraSpace.xxxl,
                      AuraSpace.lg,
                      AuraSpace.xxxl,
                    ),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      final isActive = index == active;
                      return PressableScale(
                        haptic: false,
                        scale: 0.99,
                        onTap: () {
                          if (!document.isSynced) return;
                          ref
                              .read(playerControllerProvider.notifier)
                              .seek(
                                Duration(
                                  milliseconds:
                                      (line.t - document.offsetMs).clamp(0, 1 << 30),
                                ),
                              );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AuraSpace.xs,
                          ),
                          child: _LyricLineView(
                            line: line,
                            active: isActive,
                            progress: isActive
                                ? lineProgress(line, player.position)
                                : 0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _OffsetBar(
                offsetMs: document.offsetMs,
                enabled: document.isSynced,
                onChanged: (value) async {
                  try {
                    await ref
                        .read(libraryRepositoryProvider)
                        .setLyricsOffset(track.id, value);
                    ref.invalidate(lyricsProvider(track.id));
                  } catch (_) {
                    // Offline: keep the current offset.
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LyricLineView extends StatelessWidget {
  const _LyricLineView({
    required this.line,
    required this.active,
    required this.progress,
  });

  final LyricLine line;
  final bool active;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    final style = AuraType.title2.copyWith(
      color: active ? colors.textPrimary : colors.textTertiary,
      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
      height: 1.25,
    );
    final text = line.text.isEmpty ? '♪' : line.text;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      style: style,
      child: active && progress > 0
          ? ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  colors.textPrimary,
                  colors.textPrimary,
                  colors.textTertiary,
                  colors.textTertiary,
                ],
                stops: [
                  0,
                  progress.clamp(0.0, 1.0),
                  progress.clamp(0.0, 1.0),
                  1,
                ],
              ).createShader(bounds),
              child: Text(text),
            )
          : Text(text),
    );
  }
}

class _OffsetBar extends StatelessWidget {
  const _OffsetBar({
    required this.offsetMs,
    required this.enabled,
    required this.onChanged,
  });

  final int offsetMs;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AuraSpace.md,
        AuraSpace.xs,
        AuraSpace.md,
        MediaQuery.paddingOf(context).bottom + AuraSpace.xs,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.lyricsOffset,
            style: AuraType.caption.copyWith(color: colors.textSecondary),
          ),
          const Spacer(),
          IconButton(
            onPressed: enabled
                ? () => onChanged((offsetMs - 500).clamp(-30000, 30000))
                : null,
            tooltip: '−0.5 s',
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 64,
            child: Text(
              '${(offsetMs / 1000).toStringAsFixed(1)} s',
              textAlign: TextAlign.center,
              style: AuraType.footnote.copyWith(
                color: colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          IconButton(
            onPressed: enabled
                ? () => onChanged((offsetMs + 500).clamp(-30000, 30000))
                : null,
            tooltip: '+0.5 s',
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _EmptyLyrics extends StatelessWidget {
  const _EmptyLyrics({required this.onRetry});

  final VoidCallback onRetry;

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
              Icons.lyrics_outlined,
              size: 44,
              color: colors.textTertiary,
            ),
            const SizedBox(height: AuraSpace.md),
            Text(
              context.l10n.noLyrics,
              textAlign: TextAlign.center,
              style: AuraType.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AuraSpace.md),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
