import 'package:dio/dio.dart';

class DioFactory {
  static const String baseUrl = "https:localhost:3000/api";
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;

  static Dio createDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: connectTimeoutSeconds),
        receiveTimeout: const Duration(seconds: receiveTimeoutSeconds),
        sendTimeout: const Duration(seconds: receiveTimeoutSeconds),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // TODO: INTERCEPTORES
    dio.interceptors.add(InterceptorsWrapper());
    return dio;
  }
}
