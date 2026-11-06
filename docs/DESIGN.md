# Aura — Design System

The reference is "iPhone clean": calm surfaces, one accent, generous spacing,
soft depth, and motion that explains rather than decorates. The UI is written in
Spanish; code and identifiers are English.

## Principles

1. **Content first.** Artwork, titles and lyrics carry the color. Chrome stays
   quiet and translucent.
2. **One accent.** Indigo (`#7C9CFF` dark / `#4C6FFF` light) marks action and
   current state. Nothing else competes.
3. **Motion with meaning.** Every transition maps to a spatial relationship
   (push, slide-up, fade). Nothing loops in the foreground.
4. **Offline is normal.** Cached content renders immediately; sync state is a
   small, non-blocking indicator.
5. **Respect the user.** Text scaling is honored, reduce-motion disables
   animation, contrast targets WCAG AA.

## Tokens

Defined in `app/lib/core/design/tokens.dart` and exposed as a `ThemeExtension`,
so widgets never hard-code colors.

### Color

| Token | Dark | Light | Use |
| --- | --- | --- | --- |
| `background` | `#07080B` | `#F6F7FA` | app canvas |
| `backgroundElevated` | `#0D0F14` | `#EDEFF5` | sheets/dialogs |
| `surface` | `#14161D` | `#FFFFFF` | cards, inputs |
| `surfaceStrong` | `#1C1F28` | `#F0F2F8` | pressed/raised |
| `textPrimary` | `#F4F5F8` | `#0C0D11` | titles |
| `textSecondary` | `#A6ABBA` | `#5E6373` | metadata |
| `textTertiary` | `#6E7485` | `#8A8F9E` | hints |
| `accent` | `#7C9CFF` | `#4C6FFF` | actions, active tab |
| `accentSoft` | 20% accent | 10% accent | selected rows |
| `success` | `#5BD6A2` | `#178A5E` | completed |
| `warning` | `#F2C46D` | `#9A6B00` | review needed |
| `danger` | `#FF7A7A` | `#C73838` | errors/destructive |
| `glassTint` | `#14FFFFFF` | `#B3FFFFFF` | frosted surfaces |
| `glassBorder` | `#1FFFFFFF` | `#1F000000` | hairline |
| `divider` | `#14FFFFFF` | `#14000000` | separators |

Album art is allowed to introduce its own palette (from the cover endpoint).
The palette is used for a soft gradient placeholder and an optional tinted
shadow, never for text.

### Spacing

A 4 pt grid: `4, 8, 12, 16, 20, 24, 32, 40, 56`. Screen gutters are 16; large
titles start at 16 and use the Cupertino large-title behavior.

### Radii

`10` small controls, `14` cards/inputs, `18` sheets, `24` glass panels, `32`
hero cards, `999` pills, plus `RoundedSuperellipseBorder` for buttons and
bottom sheets (iOS-like continuous corners).

### Type

Inter on Android/Windows/web; the system font on Apple platforms. The ramp is
fixed in size (no shrinking) and scales with the OS text size.

| Style | Size / weight | Use |
| --- | --- | --- |
| `largeTitle` | 34 / 700 | screen title |
| `title1` | 28 / 700 | hero |
| `title2` | 22 / 700 | section |
| `title3` | 20 / 600 | card title |
| `headline` | 17 / 600 | rows, buttons |
| `body` | 17 / 400 | body |
| `callout` | 16 / 400 | secondary body |
| `subhead` | 15 / 400 | metadata |
| `footnote` | 13 / 400 | captions |
| `caption` | 12 / 500 | labels |

## Surfaces and depth

- **Glass** (`GlassSurface`): blur 22, tint + hairline border, used only for the
  tab bar, mini player and login card. At most two visible at once.
- **Cards**: flat surface with 1 px divider or a very soft shadow, radius 14.
- **Gradient background**: three blurred palette blobs at low opacity. Paused
  when reduce motion is on.
- **Cover art**: palette gradient (instant) → thumbhash (blurred preview) →
  network WebP (fade 800 ms). Errors collapse to the gradient, never a broken
  image icon.

## Motion

| Token | Duration | Use |
| --- | --- | --- |
| `quick` | 200 ms | taps, toggles |
| `standard` | 280 ms | page fades, list changes |
| `expressive` | 350 ms | sheets, player |
| `cover` | 800 ms | artwork fade |

Curves: `easeOutCubic` by default, `Cubic(0.22, 1, 0.36, 1)` for emphasized
entrances. The player and lyrics use a slide-up page (340 ms in, 300 ms out).
Press feedback is a subtle scale (`PressableScale`). All durations become zero
when the OS requests reduced motion.

## Screens

| Route | Screen | Notes |
| --- | --- | --- |
| `/splash` | brand mark | shown while auth is restored |
| `/login` | email + password | glass card, inline validation, Spanish errors |
| `/library` | songs / albums / artists | segmented control, pull-to-refresh, sync button |
| `/search` | local + remote search | debounced, grouped results |
| `/settings` | preferences | theme, volume normalization, Wi-Fi-only, cache |
| `/album/:id` | album detail | hero cover, track list |
| `/artist/:id` | artist detail | image, albums, tracks |
| `/player` | now playing | artwork, scrubber, queue, sleep timer |
| `/lyrics` | synced lyrics | auto-scroll, tap a line to seek |
| `/gallery` | component gallery | debug-only visual QA |

### States

- **Loading**: skeletons with the same geometry as the final content.
- **Empty**: one line of copy plus a single action; no illustrations.
- **Error**: plain Spanish sentence plus retry; never a raw exception.
- **Offline**: cached metadata, lyrics, queue and play events stay usable;
  audio itself is streamed unless the file is already cached locally. Sync
  errors surface as a quiet, retryable message instead of a blocking dialog.
- **Long lists**: lazy slivers; artwork is decoded at display size.

## Accessibility

- Minimum touch target 44×44.
- Semantic labels on icon-only buttons (tooltips/localized labels).
- Contrast: primary text on background ≥ 7:1; secondary ≥ 4.5:1.
- Text scaling: layouts use `Wrap`/`Flexible`, no fixed-height text rows.
- Reduce motion and reduce transparency are read from `MediaQuery`.
- Destructive actions are confirmed and use the danger token.

## Copy (Spanish)

- Sentence case, second person (`tú`), no exclamation marks.
- Buttons are verbs: `Entrar`, `Descargar`, `Quitar descarga`.
- Errors explain the next step: "No se pudo conectar. Revisa tu red e inténtalo
  de nuevo."
- Dates and numbers use `intl` with the `es` locale; durations are `m:ss` or
  `h:mm:ss`.

## Verification

- `flutter analyze` must be clean.
- Unit/widget tests cover the queue, LRC parsing, models, Drift cache, auth and
  router.
- One golden (`app/test/goldens/login_screen.png`) protects the login baseline;
  it is generated on Windows and skipped on other hosts because text
  rasterization differs.
- The debug gallery (`/gallery`) is the manual checklist for components in both
  themes.
