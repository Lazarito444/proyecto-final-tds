import 'dart:io';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/models/dashboard_model.dart';
import 'package:financia_mobile/config/app_preferences.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final dashboardService = ref.watch(dashboardServiceProvider);
  try {
    return await dashboardService.getDashboardData();
  } catch (e) {
    debugPrint('Error en el proveedor de datos del dashboard: $e');
    rethrow;
  }
});

class DashboardService {
  final Dio dio = DioFactory.createDio();

  Future<DashboardData> getDashboardData() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      debugPrint('Token de acceso para el dashboard: $token');

      final response = await dio.get(
        'dashboard-data',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        debugPrint('Respuesta de la API para el dashboard: $json');
        return DashboardData.fromJson(json);
      } else {
        throw Exception(
          "Error al cargar los datos del dashboard: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Error de red: ${e.type}. Mensaje: ${e.message}";
      if (e.response != null) {
        errorMessage +=
            ". Código de estado: ${e.response!.statusCode}. Datos: ${e.response!.data}";
      }
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
