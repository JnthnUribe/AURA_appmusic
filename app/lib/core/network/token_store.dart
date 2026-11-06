import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/models.dart';

abstract interface class TokenStore {
  Future<TokenPair?> read();

  Future<void> write(TokenPair pair);

  Future<void> clear();
}

/// Production storage: Keychain on iOS, Keystore on Android, DPAPI on Windows.
class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'aura.tokens.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<TokenPair?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return TokenPair.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(TokenPair pair) {
    return _storage.write(
      key: _key,
      value: jsonEncode({
        'access_token': pair.accessToken,
        'refresh_token': pair.refreshToken,
        'access_expires_at': pair.accessExpiresAt.toUtc().toIso8601String(),
        'refresh_expires_at': pair.refreshExpiresAt.toUtc().toIso8601String(),
      }),
    );
  }

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Deterministic store for tests and previews.
class MemoryTokenStore implements TokenStore {
  MemoryTokenStore([this._pair]);

  TokenPair? _pair;

  @override
  Future<TokenPair?> read() async => _pair;

  @override
  Future<void> write(TokenPair pair) async => _pair = pair;

  @override
  Future<void> clear() async => _pair = null;
}
