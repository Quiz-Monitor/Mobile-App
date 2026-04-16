import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:examify/core/networking/auth_interceptor.dart';
import 'package:examify/core/storage/session_storage.dart';
//import 'package:flutter_complete_project/core/helpers/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;
  static SessionStorage? _sessionStorage;

  static void initSessionStorage(SessionStorage sessionStorage) {
    _sessionStorage = sessionStorage;
  }

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      // Allow self-signed certificates for local development
      (dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    if (_sessionStorage != null) {
      dio?.interceptors.add(AuthInterceptor(_sessionStorage!));
    }

    if (!kDebugMode) {
      return;
    }

    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }
}
