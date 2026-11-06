import '../../core/models/models.dart';
import '../../core/network/api_client.dart';
import '../../core/network/token_store.dart';

class AuthRepository {
  AuthRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<bool> hasSession() async => (await _client.tokens.read()) != null;

  Future<User> login({required String email, required String password}) async {
    final data = await _client.post(
      '/v1/auth/login',
      data: {'email': email.trim(), 'password': password},
    ) as Map<String, dynamic>;
    await _client.tokens.write(TokenPair.fromJson(data));
    return currentUser();
  }

  Future<User> currentUser() async {
    final data = await _client.get('/v1/auth/me') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<void> logout() async {
    final pair = await _client.tokens.read();
    try {
      if (pair != null) {
        await _client.post(
          '/v1/auth/logout',
          data: {'refresh_token': pair.refreshToken},
        );
      }
    } finally {
      await _client.tokens.clear();
    }
  }
}

/// Small helper used by tests and the preview gallery.
class FixedTokenStore implements TokenStore {
  FixedTokenStore(this.pair);

  TokenPair? pair;

  @override
  Future<void> clear() async => pair = null;

  @override
  Future<TokenPair?> read() async => pair;

  @override
  Future<void> write(TokenPair value) async => pair = value;
}
