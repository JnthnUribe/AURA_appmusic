import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../models/models.dart';
import 'api_exception.dart';
import 'token_store.dart';

/// Thin typed wrapper over Dio with JWT refresh, retries and problem+json.
class ApiClient {
  ApiClient({
    required AppConfig config,
    required TokenStore tokens,
    Dio? dio,
    Dio? refreshDio,
  }) : _tokens = tokens,
       _dio = dio ?? _defaultDio(config),
       _refreshDio = refreshDio ?? _defaultDio(config) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final pair = await _tokens.read();
          if (pair != null && !options.path.contains('/v1/auth/')) {
            options.headers['Authorization'] = 'Bearer ${pair.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final options = error.requestOptions;
          final isAuthCall = options.path.contains('/v1/auth/');
          final alreadyRetried = options.extra['aura_retried'] == true;
          if (error.response?.statusCode != 401 ||
              isAuthCall ||
              alreadyRetried) {
            handler.next(error);
            return;
          }
          final refreshed = await _refresh();
          if (!refreshed) {
            handler.next(error);
            return;
          }
          final pair = await _tokens.read();
          options.extra['aura_retried'] = true;
          options.headers['Authorization'] = 'Bearer ${pair!.accessToken}';
          try {
            handler.resolve(await _dio.fetch<dynamic>(options));
          } on DioException catch (retryError) {
            handler.next(retryError);
          }
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }
  }

  final Dio _dio;
  final Dio _refreshDio;
  final Dio _downloadDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );
  final TokenStore _tokens;
  Future<bool>? _refreshing;

  TokenStore get tokens => _tokens;

  static Dio _defaultDio(AppConfig config) {
    return Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 25),
        sendTimeout: const Duration(seconds: 25),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) => status != null && status < 400,
      ),
    );
  }

  Future<bool> _refresh() {
    return _refreshing ??= _performRefresh().whenComplete(() {
      _refreshing = null;
    });
  }

  Future<bool> _performRefresh() async {
    final pair = await _tokens.read();
    if (pair == null) return false;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/v1/auth/refresh',
        data: {'refresh_token': pair.refreshToken},
      );
      final data = response.data;
      if (data == null) return false;
      await _tokens.write(TokenPair.fromJson(data));
      return true;
    } on DioException {
      await _tokens.clear();
      return false;
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) => _request(() => _dio.get<dynamic>(path, queryParameters: query, options: options));

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) => _request(() => _dio.post<dynamic>(path, data: data, queryParameters: query));

  Future<dynamic> put(String path, {Object? data}) =>
      _request(() => _dio.put<dynamic>(path, data: data));

  Future<dynamic> patch(String path, {Object? data}) =>
      _request(() => _dio.patch<dynamic>(path, data: data));

  Future<dynamic> delete(String path, {Object? data}) =>
      _request(() => _dio.delete<dynamic>(path, data: data));

  /// Downloads a signed media URL straight to disk, with progress and
  /// cancellation. A separate Dio instance avoids sending the JWT to R2.
  Future<void> download(
    String url,
    String path, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _downloadDio.download(
        url,
        path,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
        deleteOnError: true,
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<dynamic> _request(Future<Response<dynamic>> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
