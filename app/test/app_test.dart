import 'package:aura/app.dart';
import 'package:aura/core/providers.dart';
import 'package:aura/core/design/aura_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/test_harness.dart';

void main() {
  testWidgets('signed-out users are redirected from splash to login', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const AuraApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Entra en tu música'), findsOneWidget);
    expect(find.text('Aura'), findsNothing);
  });

  testWidgets('theme and Spanish localization are wired into the app', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'settings.theme': 'dark'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const AuraApp(),
      ),
    );

    final context = tester.element(find.byType(Scaffold).first);
    expect(Localizations.localeOf(context), const Locale('es'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(AuraTheme.dark().scaffoldBackgroundColor, isNot(Colors.white));
  });
}
