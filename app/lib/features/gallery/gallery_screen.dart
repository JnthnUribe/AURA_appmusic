import 'package:flutter/material.dart';

import '../../components/aura_scaffold.dart';
import '../../components/cover_art.dart';
import '../../components/glass_surface.dart';
import '../../components/pressable_scale.dart';
import '../../components/segmented_control.dart';
import '../../components/skeleton.dart';
import '../../components/toast.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';

/// Debug-only component gallery (`/gallery`, dev flavor).
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _segment = 0;
  bool _switch = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return AuraScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AuraSpace.md),
          children: [
            Text(
              context.l10n.designSystem,
              style: AuraType.largeTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AuraSpace.lg),
            _label('Color', colors),
            Wrap(
              spacing: AuraSpace.xs,
              runSpacing: AuraSpace.xs,
              children: [
                _swatch(colors.accent, 'accent'),
                _swatch(colors.success, 'success'),
                _swatch(colors.warning, 'warning'),
                _swatch(colors.danger, 'danger'),
                _swatch(colors.surface, 'surface'),
                _swatch(colors.surfaceStrong, 'strong'),
              ],
            ),
            const SizedBox(height: AuraSpace.xl),
            _label('Tipografía', colors),
            Text('Large Title 34', style: AuraType.largeTitle),
            Text('Title 28', style: AuraType.title1),
            Text('Title 22', style: AuraType.title2),
            Text('Headline 17', style: AuraType.headline),
            Text('Body 17 — La música suena mejor cuando todo está a mano.',
                style: AuraType.body),
            Text('Footnote 13', style: AuraType.footnote),
            const SizedBox(height: AuraSpace.xl),
            _label('Superficies', colors),
            Row(
              children: [
                CoverArt(
                  albumId: null,
                  size: 96,
                  placeholderSeed: 'Aura',
                ),
                const SizedBox(width: AuraSpace.md),
                Expanded(
                  child: GlassSurface(
                    padding: const EdgeInsets.all(AuraSpace.md),
                    child: Text(
                      'GlassSurface',
                      style: AuraType.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AuraSpace.md),
            const TrackTileSkeleton(),
            const SizedBox(height: AuraSpace.xl),
            _label('Controles', colors),
            SegmentedControl<int>(
              value: _segment,
              onChanged: (value) => setState(() => _segment = value),
              items: const [
                SegmentItem(value: 0, label: 'Uno'),
                SegmentItem(value: 1, label: 'Dos'),
                SegmentItem(value: 2, label: 'Tres'),
              ],
            ),
            const SizedBox(height: AuraSpace.md),
            SwitchListTile(
              value: _switch,
              onChanged: (value) => setState(() => _switch = value),
              title: const Text('Switch'),
            ),
            const SizedBox(height: AuraSpace.md),
            Row(
              children: [
                FilledButton(
                  onPressed: () => AuraToast.show(context, 'Toast de Aura'),
                  child: const Text('Filled'),
                ),
                const SizedBox(width: AuraSpace.sm),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
              ],
            ),
            const SizedBox(height: AuraSpace.xl),
            _label('Press scale', colors),
            PressableScale(
              onTap: () {},
              child: Container(
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(AuraRadius.md),
                ),
                child: Text(
                  'Mantén pulsado',
                  style: AuraType.callout.copyWith(color: colors.textPrimary),
                ),
              ),
            ),
            const SizedBox(height: AuraSpace.xxl),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, AuraColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AuraSpace.xs),
      child: Text(
        text.toUpperCase(),
        style: AuraType.caption.copyWith(
          color: colors.textTertiary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _swatch(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AuraRadius.sm),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AuraType.caption),
      ],
    );
  }
}
