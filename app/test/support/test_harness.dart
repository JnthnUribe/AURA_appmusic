import 'package:aura/core/design/aura_theme.dart';
import 'package:aura/core/models/models.dart';
import 'package:aura/core/providers.dart';
import 'package:aura/data/repositories/auth_repository.dart';
import 'package:aura/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Auth repository that never touches the network, so widget tests stay fast
/// and deterministic.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.signedIn = false,
    this.loginResult,
    this.loginError,
  });

  bool signedIn;
  User? loginResult;
  Object? loginError;

  int loginCalls = 0;
  int logoutCalls = 0;

  static const demoUser = User(
    id: 'u1',
    email: 'demo@aura.test',
    displayName: 'Demo',
    timezone: 'Europe/Madrid',
  );

  @override
  Future<bool> hasSession() async => signedIn;

  @override
  Future<User> currentUser() async {
    if (!signedIn) throw StateError('No session');
    return demoUser;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    loginCalls++;
    final error = loginError;
    if (error != null) throw error;
    signedIn = true;
    return loginResult ?? demoUser;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    signedIn = false;
  }
}

/// Wraps [child] in the same theme, locale and providers as the real app.
Widget testApp({
  required Widget child,
  FakeAuthRepository? auth,
  List<Override> overrides = const [],
  bool reduceMotion = true,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth ?? FakeAuthRepository()),
      ...overrides,
    ],
    child: MaterialApp(
      theme: AuraTheme.light(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, app) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(disableAnimations: reduceMotion),
          child: app!,
        );
      },
      home: child,
    ),
  );
}

/// Pumps [child] and lets the auth restore microtask settle without waiting on
/// the infinite ambient gradient animation.
Future<void> pumpTestApp(
  WidgetTester tester, {
  required Widget child,
  FakeAuthRepository? auth,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    testApp(child: child, auth: auth, overrides: overrides),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
}

ProviderContainer containerOf(WidgetTester tester) {
  return ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
    listen: false,
  );
}
