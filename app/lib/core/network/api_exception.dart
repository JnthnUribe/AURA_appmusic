import 'package:dio/dio.dart';

/// RFC 9457 `application/problem+json` mapped to something UI can show.
class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    this.title,
    this.detail,
    this.code,
    this.requestId,
    this.errors = const [],
    this.isNetworkError = false,
  });

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    if (response == null ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return ApiException(
        statusCode: 0,
        title: 'network',
        detail: error.message,
        isNetworkError: true,
      );
    }
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiException(
        statusCode: response.statusCode ?? 0,
        title: data['title'] as String?,
        detail: data['detail'] as String?,
        code: data['code'] as String?,
        requestId: data['request_id'] as String?,
        errors: (data['errors'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false),
      );
    }
    return ApiException(
      statusCode: response.statusCode ?? 0,
      detail: response.statusMessage,
    );
  }

  final int statusCode;
  final String? title;
  final String? detail;
  final String? code;
  final String? requestId;
  final List<Map<String, dynamic>> errors;
  final bool isNetworkError;

  bool get isUnauthorized => statusCode == 401;

  String get userMessage {
    if (isNetworkError) {
      return 'No se pudo conectar. Revisa tu red e inténtalo de nuevo.';
    }
    if (statusCode == 401) return 'Tu sesión ha caducado. Vuelve a entrar.';
    if (statusCode == 404) return 'No encontramos eso.';
    if (statusCode == 429) {
      return 'Demasiadas peticiones. Espera un momento.';
    }
    return detail ?? title ?? 'Algo salió mal. Inténtalo de nuevo.';
  }

  @override
  String toString() => 'ApiException($statusCode, $title, $detail)';
}
