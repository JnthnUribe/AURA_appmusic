import 'package:aura/core/network/api_exception.dart';
import 'package:aura/features/auth/auth_controller.dart';
import 'package:aura/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_harness.dart';

void main() {
  testWidgets('renders the Spanish sign-in experience', (tester) async {
    await pumpTestApp(tester, child: const LoginScreen());

    expect(find.text('Entra en tu música'), findsOneWidget);
    expect(
      find.text('Tu biblioteca, tus portadas y tus letras. En cualquier lugar.'),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);

    // The password starts hidden and the eye toggle reveals it.
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isTrue,
    );
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
  });

  testWidgets('blocks submission until the form is valid', (tester) async {
    final auth = FakeAuthRepository();
    await pumpTestApp(tester, child: const LoginScreen(), auth: auth);

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(auth.loginCalls, 0);

    await tester.enterText(find.byType(TextFormField).first, 'demo@aura.test');
    await tester.enterText(find.byType(TextFormField).last, 'short');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(auth.loginCalls, 0);
  });

  testWidgets('shows the invalid credentials message on 401', (tester) async {
    final auth = FakeAuthRepository(
      loginError: ApiException(statusCode: 401),
    );
    await pumpTestApp(tester, child: const LoginScreen(), auth: auth);

    await tester.enterText(find.byType(TextFormField).first, 'demo@aura.test');
    await tester.enterText(find.byType(TextFormField).last, 'correct-horse');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(auth.loginCalls, 1);
    expect(find.text('Correo o contraseña incorrectos.'), findsOneWidget);
  });

  testWidgets('signs in and exposes the authenticated state', (tester) async {
    final auth = FakeAuthRepository();
    await pumpTestApp(tester, child: const LoginScreen(), auth: auth);

    await tester.enterText(find.byType(TextFormField).first, 'demo@aura.test');
    await tester.enterText(find.byType(TextFormField).last, 'correct-horse');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(auth.loginCalls, 1);
    final state = containerOf(tester).read(authControllerProvider);
    expect(state, isA<AuthSignedIn>());
    expect((state as AuthSignedIn).user.email, 'demo@aura.test');
  });

  testWidgets('restores a signed-out session without a stored token', (
    tester,
  ) async {
    await pumpTestApp(tester, child: const LoginScreen());

    // Instantiating the controller starts the restore microtask.
    final container = containerOf(tester);
    container.read(authControllerProvider);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    expect(
      container.read(authControllerProvider),
      isA<AuthSignedOut>(),
    );
  });
}
