import 'dart:io';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:flutter/foundation.dart'
    as flutter; // Added alias to avoid Category name conflict
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/models/dashboard_model.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/category_model.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final dashboardService = ref.watch(dashboardServiceProvider);
  try {
    return await dashboardService.getDashboardData();
  } catch (e) {
    flutter.debugPrint(
      'Error en el proveedor de datos del dashboard: $e',
    ); // Updated to use flutter prefix
    rethrow;
  }
});

class DashboardService {
  final Dio dio = DioFactory.createDio();

  Future<DashboardData> getDashboardData() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      flutter.debugPrint(
        'Token de acceso para el dashboard: $token',
      ); // Updated to use flutter prefix

      final dashboardResponse = await dio.get(
        'dashboard-data',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );

      final categoriesResponse = await dio.get(
        'categories',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );

      if (dashboardResponse.statusCode == 200 &&
          categoriesResponse.statusCode == 200) {
        final dashboardJson = dashboardResponse.data as Map<String, dynamic>;
        final categoriesJson = categoriesResponse.data as List<dynamic>;

        flutter.debugPrint(
          'Respuesta de la API para el dashboard: $dashboardJson',
        ); // Updated to use flutter prefix
        flutter.debugPrint(
          'Respuesta de categorías: $categoriesJson',
        ); // Updated to use flutter prefix

        final categoryMap = <String, Category>{};
        for (final categoryData in categoriesJson) {
          final category = Category.fromJson(
            categoryData as Map<String, dynamic>,
          );
          categoryMap[category.name] = category;
        }

        final dashboardData = DashboardData.fromJson(dashboardJson);

        final enrichedTransactions = dashboardData.userLastTransactions.map((
          transaction,
        ) {
          final category = categoryMap[transaction.categoryName];
          if (category != null) {
            return Transaction(
              id: transaction.id,
              amount: transaction.amount,
              description: transaction.description,
              categoryName: transaction.categoryName,
              dateTime: transaction.dateTime,
              isEarningCategory: transaction.isEarningCategory,
              iconName: category.iconName,
              colorHex: category.colorHex,
            );
          }
          return transaction;
        }).toList();

        return DashboardData(
          userLastTransactions: enrichedTransactions,
          earnings: dashboardData.earnings,
          expenses: dashboardData.expenses,
          earningsByCategory: dashboardData.earningsByCategory,
          expensesByCategory: dashboardData.expensesByCategory,
        );
      } else {
        throw Exception(
          "Error al cargar los datos del dashboard: ${dashboardResponse.statusMessage}",
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Error de red: ${e.type}. Mensaje: ${e.message}";
      if (e.response != null) {
        errorMessage +=
            ". Código de estado: ${e.response!.statusCode}. Datos: ${e.response!.data}";
      }
      flutter.debugPrint(errorMessage); // Updated to use flutter prefix
      throw Exception(errorMessage);
    }
  }
}


/*
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
*/ 