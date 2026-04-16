import 'package:dio/dio.dart';
import 'package:examify/core/storage/session_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionStorage);

  final SessionStorage _sessionStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionStorage.getAccessToken();

    options.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Placeholder for future refresh-token retry strategy.
    // if (err.response?.statusCode == 401) { ... }
    handler.next(err);
  }
}
