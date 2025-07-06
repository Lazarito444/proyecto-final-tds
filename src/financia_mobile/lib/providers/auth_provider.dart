import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:financia_mobile/models/register_model.dart';
import 'package:financia_mobile/models/system_tokens.dart';
import 'package:financia_mobile/services/auth_service.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthState {
  final AuthStatus status;
  final SystemTokens? tokens;

  AuthState({required this.status, this.tokens});

  AuthState copyWith({AuthStatus? status, SystemTokens? tokens}) {
    return AuthState(
      status: status ?? this.status,
      tokens: tokens ?? this.tokens,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _init(); // no await, solo lanzar async
    return AuthState(status: AuthStatus.loading);
  }

  Future<void> _init() async {
    final tokens = await _authService.loadTokens();

    if (tokens == null) {
      state = AuthState(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final refreshed = await _authService.refreshToken();
      if (refreshed != null) {
        state = AuthState(status: AuthStatus.authenticated, tokens: refreshed);
      } else {
        await logout();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
      } else {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final tokens = await _authService.login(email, password);
      state = AuthState(status: AuthStatus.authenticated, tokens: tokens);
    } on DioException {
      state = AuthState(status: AuthStatus.unauthenticated);
      throw Exception("Credenciales incorrectas");
    }
  }

  Future<void> register(RegisterModel model) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final tokens = await _authService.register(model);
      state = AuthState(status: AuthStatus.authenticated, tokens: tokens);
    } on DioException {
      state = AuthState(status: AuthStatus.unauthenticated);
      throw Exception("Error al crear usuario");
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> refreshTokens() async {
    final tokens = await _authService.refreshToken();
    if (tokens != null) {
      state = AuthState(status: AuthStatus.authenticated, tokens: tokens);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
