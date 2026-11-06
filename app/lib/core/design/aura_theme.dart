import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AuraTheme {
  static final _apple = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static const scrollBehavior = AuraScrollBehavior();

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final fontFamily = _apple ? null : 'Inter';
    final colors =
        brightness == Brightness.dark ? AuraColors.dark : AuraColors.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.accent,
      brightness: brightness,
    ).copyWith(
      primary: colors.accent,
      onPrimary: brightness == Brightness.dark
          ? const Color(0xFF06070A)
          : Colors.white,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      error: colors.danger,
      outline: colors.divider,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.background,
      fontFamily: _apple ? null : 'Inter',
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme
        .apply(
          bodyColor: colors.textPrimary,
          displayColor: colors.textPrimary,
        )
        .copyWith(
          displayLarge: AuraType.largeTitle,
          displayMedium: AuraType.title1,
          displaySmall: AuraType.title2,
          headlineLarge: AuraType.title1,
          headlineMedium: AuraType.title2,
          headlineSmall: AuraType.title3,
          titleLarge: AuraType.headline,
          titleMedium: AuraType.callout,
          titleSmall: AuraType.subhead,
          bodyLarge: AuraType.body,
          bodyMedium: AuraType.callout,
          bodySmall: AuraType.footnote,
          labelLarge: AuraType.headline,
          labelMedium: AuraType.footnote,
          labelSmall: AuraType.caption,
        )
        .apply(fontFamily: fontFamily);

    return base.copyWith(
      textTheme: textTheme,
      extensions: [colors],
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: colors.textPrimary, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: AuraType.body.copyWith(
          fontFamily: fontFamily,
          color: colors.textTertiary,
        ),
        labelStyle: AuraType.callout.copyWith(
          fontFamily: fontFamily,
          color: colors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AuraSpace.md,
          vertical: AuraSpace.md,
        ),
        border: _inputBorder(colors.divider),
        enabledBorder: _inputBorder(colors.divider),
        focusedBorder: _inputBorder(colors.accent, width: 1.4),
        errorBorder: _inputBorder(colors.danger),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor:
              brightness == Brightness.dark ? const Color(0xFF06070A) : Colors.white,
          minimumSize: const Size(64, 52),
          textStyle: AuraType.headline.copyWith(fontFamily: fontFamily),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadius.all(Radius.circular(AuraRadius.md)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accent,
          minimumSize: const Size(44, 44),
          textStyle: AuraType.callout.copyWith(fontFamily: fontFamily),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.backgroundElevated,
        modalBackgroundColor: colors.backgroundElevated,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: colors.textTertiary,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AuraRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.backgroundElevated,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(AuraRadius.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceStrong,
        contentTextStyle: AuraType.subhead.copyWith(
          fontFamily: fontFamily,
          color: colors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(AuraRadius.pill)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : colors.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.surfaceStrong,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.accent),
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: AuraSpace.md),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(AuraRadius.md)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Bouncing scroll physics everywhere, like iOS, including pointer devices.
class AuraScrollBehavior extends MaterialScrollBehavior {
  const AuraScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
