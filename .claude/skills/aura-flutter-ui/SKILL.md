---
name: aura-flutter-ui
description: Use when creating or changing Flutter screens, components, animations, themes, layout or accessibility in Aura. Do not use for backend or worker code.
---

# Aura Flutter UI

## Non-negotiables

- UI copy in Spanish; identifiers and comments in English.
- Read colors/spacing/radii from `core/design/tokens.dart` (`context.auraColors`).
  No `Color(0x...)` in feature widgets.
- Use `AuraScaffold` for screen backgrounds and `GlassSurface` only for the tab
  bar, mini player and login card (max two visible).
- Respect `MediaQuery.disableAnimations` through `AuraMotion`; never animate
  forever in the foreground.
- Minimum 44×44 touch targets; icon-only buttons need a localized tooltip.
- Support text scaling: `Flexible`/`Wrap`, no fixed-height text rows.

## Components

Reuse `components/`: `PressableScale`, `GlassSurface`, `CoverArt`, `TrackTile`,
`SegmentedControl`, `Skeleton`, `SectionHeader`, `HorizontalShelf`, `Toast`.
If a new pattern appears twice, promote it to `components/` before using it a
third time.

## Screens and routing

- Routes live in `lib/router/app_router.dart`; auth redirects are centralized
  there.
- Screens read from providers backed by Drift; never call Dio directly from a
  widget.
- Every async screen has loading (skeleton), empty, error (Spanish, retry) and
  data states.
- The player and lyrics pages use the slide-up transition; other pushes use the
  Cupertino builder.

## Playback and lyrics

- Queue invariants live in `queue_engine.dart` and are unit-tested; do not
  duplicate them in widgets.
- The mini player is the single source for `showMiniPlayer`; do not stack two.
- Lyrics scroll uses the shared active-line logic; tap seeks, not scrolls.

## Performance

- Decode artwork at display size (`cacheWidth`); avoid large images in lists.
- Use slivers and const widgets; no `shrinkWrap` lists inside scroll views.
- Keep glass/blur off scrolling list items.
- Do not rebuild the whole tree on position ticks; scope listeners to the
  progress widget.

## Tests and checks

Run `flutter analyze` and `flutter test`. Add widget tests for new interactive
flows and a golden only for stable, high-value screens (Windows reference host).
`dart run build_runner build --force-jit` after Drift/l10n changes.

## Definition of done

No analyzer issues, Spanish copy reviewed, both themes checked, reduced motion
and text scaling checked, and the debug gallery updated when adding a component.
