import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/providers.dart';
import '../../data/repositories/auth_repository.dart';

sealed class AuthState {
  const AuthState();
}

class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.message});

  final String? message;
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.user);

  final User user;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future<void>.microtask(_restore);
    return const AuthUnknown();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _restore() async {
    try {
      if (await _repository.hasSession()) {
        state = AuthSignedIn(await _repository.currentUser());
        return;
      }
    } catch (_) {
      // A stale token is not a crash: fall through to the login screen.
    }
    state = const AuthSignedOut();
  }

  Future<void> login({required String email, required String password}) async {
    final user = await _repository.login(email: email, password: password);
    state = AuthSignedIn(user);
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      state = const AuthSignedOut();
    }
  }

  Future<void> refreshUser() async {
    if (state is! AuthSignedIn) return;
    try {
      state = AuthSignedIn(await _repository.currentUser());
    } catch (_) {
      // Keep the current session; the UI can retry later.
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(authControllerProvider) is AuthSignedIn,
);
