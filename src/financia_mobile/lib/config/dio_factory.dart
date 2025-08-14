import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';

class DioFactory {
  static const String baseUrl = "http://10.0.0.13:5189/api/";
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          final String? accessToken =
              await AppPreferences.getStringPreference('accessToken');

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          if (err.response?.statusCode == 401 &&
              !err.requestOptions.extra.containsKey('isRefreshCall')) {
            try {
              final String? accessToken =
                  await AppPreferences.getStringPreference('accessToken');
              final String? refreshToken =
                  await AppPreferences.getStringPreference('refreshToken');

              if (accessToken == null || refreshToken == null) {
                return handler.next(err);
              }

              final Response<dynamic> refreshResponse = await dio.post(
                '/auth/refresh',
                data: {
                  'accessToken': accessToken,
                  'refreshToken': refreshToken,
                },
                options: Options(
                  headers: {'Content-Type': 'application/json'},
                  extra: {'isRefreshCall': true},
                ),
              );

              final String newAccessToken = refreshResponse.data['accessToken'];
              final String newRefreshToken =
                  refreshResponse.data['refreshToken'];

              // Guardar nuevos tokens
              await AppPreferences.setStringPreference(
                'accessToken',
                newAccessToken,
              );
              await AppPreferences.setStringPreference(
                'refreshToken',
                newRefreshToken,
              );

              final RequestOptions originalRequest = err.requestOptions;
              originalRequest.headers['Authorization'] =
                  'Bearer $newAccessToken';

              final Response retryResponse = await dio.fetch(originalRequest);
              return handler.resolve(retryResponse);
            } catch (e) {
              return handler.next(err);
            }
          }
          handler.next(err);
        },
      ),
    );
    return dio;
  }
}
