import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:financia_mobile/models/register_model.dart';
import 'package:financia_mobile/models/system_tokens.dart';

class AuthService {
  final Dio _dio;

  AuthService() : _dio = DioFactory.createDio();

  Future<void> saveTokens(SystemTokens tokens) async {
    await AppPreferences.setStringPreference("accessToken", tokens.accessToken);
    await AppPreferences.setStringPreference(
      "refreshToken",
      tokens.refreshToken,
    );
  }

  Future<SystemTokens?> loadTokens() async {
    final String? accessToken = await AppPreferences.getStringPreference(
      "accessToken",
    );
    final String? refreshToken = await AppPreferences.getStringPreference(
      "refreshToken",
    );

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return SystemTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clearTokens() async {
    await AppPreferences.removePreference("accessToken");
    await AppPreferences.removePreference("refreshToken");
  }

  Future<SystemTokens> login(String email, String password) async {
    final Response response = await _dio.post(
      'auth/authenticate',
      data: {'email': email, 'password': password},
    );

    final SystemTokens tokens = SystemTokens.fromJson(response.data);
    await saveTokens(tokens);
    return tokens;
  }

  Future<SystemTokens> register(RegisterModel model) async {
    final Response response = await _dio.post(
      '/auth/register',
      data: {
        'fullName': model.fullName,
        'email': model.email,
        'password': model.password,
        'passwordConfirmation': model.passwordConfirmation,
      },
    );

    final SystemTokens tokens = SystemTokens.fromJson(response.data);
    await saveTokens(tokens);
    return tokens;
  }

  Future<SystemTokens?> refreshToken() async {
    final SystemTokens? tokens = await loadTokens();
    if (tokens == null) return null;

    final Response response = await _dio.post(
      '/auth/refresh',
      data: {
        'accessToken': tokens.accessToken,
        'refreshToken': tokens.refreshToken,
      },
    );

    final SystemTokens newTokens = SystemTokens.fromJson(response.data);
    await saveTokens(newTokens);
    return newTokens;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      await clearTokens();
    } catch (_) {}
    await clearTokens();
  }
}
