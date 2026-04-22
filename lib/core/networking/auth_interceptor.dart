import 'package:dio/dio.dart';
import 'package:examify/core/constants/api_constants.dart';
import 'package:examify/core/storage/session_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionStorage, this._dio);

  final SessionStorage _sessionStorage;
  final Dio _dio;
  Future<bool>? _refreshFuture;

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
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestPath = err.requestOptions.path;
    final isRefreshRequest = requestPath.contains(ApiConstants.refreshToken);

    if (statusCode == 401 && !isRefreshRequest) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retriedResponse = await _retryRequest(err.requestOptions);
        handler.resolve(retriedResponse);
        return;
      }

      await _sessionStorage.clearSession();
    }

    handler.next(err);
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh();
    final refreshResult = await _refreshFuture!;
    _refreshFuture = null;
    return refreshResult;
  }

  Future<bool> _performRefresh() async {
    try {
      final refreshToken = await _sessionStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: <String, dynamic>{'refreshToken': refreshToken},
        options: Options(
          headers: <String, dynamic>{'Accept': 'application/json'},
        ),
      );

      final responseData = response.data ?? <String, dynamic>{};
      final newAccessToken =
          responseData['accessToken']?.toString() ??
          responseData['token']?.toString();
      final newRefreshToken = responseData['refreshToken']?.toString();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return false;
      }

      await _sessionStorage.updateTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final token = await _sessionStorage.getAccessToken();
    final updatedHeaders = Map<String, dynamic>.from(requestOptions.headers);

    if (token != null && token.isNotEmpty) {
      updatedHeaders['Authorization'] = 'Bearer $token';
    } else {
      updatedHeaders.remove('Authorization');
    }

    final retryOptions = requestOptions.copyWith(headers: updatedHeaders);
    return _dio.fetch<dynamic>(retryOptions);
  }
}
