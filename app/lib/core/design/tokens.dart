import 'package:flutter/material.dart';

/// Semantic color tokens. Dark is the default; light is a first-class theme.
@immutable
class AuraColors extends ThemeExtension<AuraColors> {
  const AuraColors({
    required this.background,
    required this.backgroundElevated,
    required this.surface,
    required this.surfaceStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.warning,
    required this.danger,
    required this.glassTint,
    required this.glassBorder,
    required this.divider,
  });

  static const dark = AuraColors(
    background: Color(0xFF07080B),
    backgroundElevated: Color(0xFF0D0F14),
    surface: Color(0xFF14161D),
    surfaceStrong: Color(0xFF1C1F28),
    textPrimary: Color(0xFFF4F5F8),
    textSecondary: Color(0xFFA6ABBA),
    textTertiary: Color(0xFF6E7485),
    accent: Color(0xFF7C9CFF),
    accentSoft: Color(0x337C9CFF),
    success: Color(0xFF5BD6A2),
    warning: Color(0xFFF2C46D),
    danger: Color(0xFFFF7A7A),
    glassTint: Color(0x14FFFFFF),
    glassBorder: Color(0x1FFFFFFF),
    divider: Color(0x14FFFFFF),
  );

  static const light = AuraColors(
    background: Color(0xFFF6F7FA),
    backgroundElevated: Color(0xFFEDEFF5),
    surface: Color(0xFFFFFFFF),
    surfaceStrong: Color(0xFFF0F2F8),
    textPrimary: Color(0xFF0C0D11),
    textSecondary: Color(0xFF5E6373),
    textTertiary: Color(0xFF8A8F9E),
    accent: Color(0xFF4C6FFF),
    accentSoft: Color(0x1A4C6FFF),
    success: Color(0xFF178A5E),
    warning: Color(0xFF9A6B00),
    danger: Color(0xFFC73838),
    glassTint: Color(0xB3FFFFFF),
    glassBorder: Color(0x1F000000),
    divider: Color(0x14000000),
  );

  final Color background;
  final Color backgroundElevated;
  final Color surface;
  final Color surfaceStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color warning;
  final Color danger;
  final Color glassTint;
  final Color glassBorder;
  final Color divider;

  @override
  AuraColors copyWith({
    Color? background,
    Color? backgroundElevated,
    Color? surface,
    Color? surfaceStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? warning,
    Color? danger,
    Color? glassTint,
    Color? glassBorder,
    Color? divider,
  }) {
    return AuraColors(
      background: background ?? this.background,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      surface: surface ?? this.surface,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      glassTint: glassTint ?? this.glassTint,
      glassBorder: glassBorder ?? this.glassBorder,
      divider: divider ?? this.divider,
    );
  }

  @override
  AuraColors lerp(covariant AuraColors? other, double t) {
    if (other == null) return this;
    return AuraColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundElevated: Color.lerp(
        backgroundElevated,
        other.backgroundElevated,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension AuraColorsX on BuildContext {
  AuraColors get auraColors => Theme.of(this).extension<AuraColors>()!;
}

/// 4 pt spacing grid.
abstract final class AuraSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
  static const huge = 56.0;
}

abstract final class AuraRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const pill = 999.0;
}

/// iOS-like type ramp. Sizes never shrink; text scaling is respected.
abstract final class AuraType {
  static const largeTitle = TextStyle(
    fontSize: 34,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );
  static const title1 = TextStyle(
    fontSize: 28,
    height: 1.14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );
  static const title2 = TextStyle(
    fontSize: 22,
    height: 1.18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );
  static const title3 = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  static const headline = TextStyle(
    fontSize: 17,
    height: 1.29,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(fontSize: 17, height: 1.41);
  static const callout = TextStyle(fontSize: 16, height: 1.37);
  static const subhead = TextStyle(fontSize: 15, height: 1.33);
  static const footnote = TextStyle(fontSize: 13, height: 1.38);
  static const caption = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
  );
}
