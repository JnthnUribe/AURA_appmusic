import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/token_store.dart';
import '../data/local/database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/library_repository.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in ProviderScope'),
);

final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: ref.watch(appConfigProvider),
    tokens: ref.watch(tokenStoreProvider),
  );
});

final databaseProvider = Provider<AuraDatabase>((ref) {
  final database = AuraDatabase(AuraDatabase.openConnection());
  ref.onDispose(database.close);
  return database;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(client: ref.watch(apiClientProvider)),
);

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(
    api: ref.watch(apiClientProvider),
    database: ref.watch(databaseProvider),
  ),
);
