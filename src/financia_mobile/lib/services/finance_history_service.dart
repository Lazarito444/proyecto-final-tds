import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:financia_mobile/models/finance_history_model.dart';
import 'package:flutter/material.dart';

class FinanceHistoryService {
  final Dio _dio = DioFactory.createDio();

  Future<List<FinanceHistoryModel>> getFinanceHistory() async {
    try {
      final token = await AppPreferences.getStringPreference('accessToken');
      if (token == null) {
        throw Exception('Token de acceso no encontrado');
      }
      _dio.options.headers['Authorization'] = 'Bearer $token';

      final transactionResponse = await _dio.get('transaction');
      final List<dynamic> transactionsData = transactionResponse.data;
      final categoryResponse = await _dio.get('category');
      final List<dynamic> categoriesData = categoryResponse.data;
      final Map<String, dynamic> categoryMap = {
        for (var cat in categoriesData) cat['id']: cat,
      };

      return transactionsData.map((transactionJson) {
        final categoryId = transactionJson['categoryId'] as String;
        final categoryJson = categoryMap[categoryId];

        if (categoryJson == null) {
          debugPrint(
            'Categoría con ID $categoryId no encontrada. Usando valores por defecto.',
          );
          return FinanceHistoryModel.fromJson(transactionJson, {
            'name': 'Sin Categoría',
            'iconName': 'attach_money',
          });
        }

        return FinanceHistoryModel.fromJson(transactionJson, categoryJson);
      }).toList();
    } on DioException catch (e) {
      debugPrint('Dio error al obtener historial: ${e.response?.data}');
      throw Exception('Error al obtener historial: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado al obtener historial: $e');
      throw Exception('Error inesperado: $e');
    }
  }
}
