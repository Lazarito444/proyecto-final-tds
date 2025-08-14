import 'package:flutter/material.dart';
import 'package:financia_mobile/models/finance_history_model.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:dio/dio.dart';

class FinanceHistoryService {
  late final Dio _dio;

  FinanceHistoryService() {
    _dio = DioFactory.createDio();
  }

  Future<List<FinanceHistoryModel>> getFinanceHistory() async {
    try {
      final transactionResponse = await _dio.get('/transaction');
      final categoryResponse = await _dio.get('/category');

      if (transactionResponse.statusCode == 200 &&
          categoryResponse.statusCode == 200) {
        final List<dynamic> transactionsData = transactionResponse.data;
        final List<dynamic> categoriesData = categoryResponse.data;

        final Map<String, Map<String, dynamic>> categoryMap = {
          for (var cat in categoriesData)
            cat['id'] as String: Map<String, dynamic>.from(cat),
        };

        return transactionsData.map((transactionJson) {
          final Map<String, dynamic> transaction = Map<String, dynamic>.from(
            transactionJson,
          );
          final categoryId = transaction['categoryId'] as String?;
          final categoryData = categoryId != null
              ? categoryMap[categoryId]
              : null;

          final Map<String, dynamic> enrichedJson = Map<String, dynamic>.from({
            ...transaction,
            'categoryIconName': categoryData?['iconName'],
            'categoryColorHex': categoryData?['colorHex'],
            'categoryName':
                categoryData?['name'] ?? transaction['categoryName'],
          });

          return FinanceHistoryModel.fromJson(enrichedJson);
        }).toList();
      } else {
        throw Exception('Failed to load finance history or categories');
      }
    } on DioException catch (e) {
      debugPrint('Dio error al obtener historial: ${e.response?.data}');
      throw Exception('Error loading finance history: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado al obtener historial: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _dio.delete('/transaction/$id');
    } on DioException catch (e) {
      throw Exception('Error al borrar: ${e.message}');
    }
  }

  Future<void> editTransaction(String id, String description, double amount, String categoryId, DateTime dateTime) async {
    try {
      final formData = FormData.fromMap({
      'description': description,
      'amount': amount,
      'categoryId': categoryId,
      'dateTime': dateTime.toIso8601String(),
      });
      await _dio.put('/transaction/$id', data: formData);
    } on DioException catch (e) {
      throw Exception('Error al editar: ${e.message}');
    }
  }
}
