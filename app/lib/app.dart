import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design/aura_theme.dart';
import 'features/settings/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';

class AuraApp extends ConsumerWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp.router(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: AuraTheme.light(),
      darkTheme: AuraTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: router,
      scrollBehavior: AuraTheme.scrollBehavior,
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
