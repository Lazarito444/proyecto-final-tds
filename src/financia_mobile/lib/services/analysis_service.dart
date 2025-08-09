import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/analysis_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.0.13:5189/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static const String _SAVINGS_GOALS_KEY = 'savingsGoals';

  Future<void> _saveGoals(List<SavingsGoal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      goals.map((goal) => goal.toJson()).toList(),
    );
    await prefs.setString(_SAVINGS_GOALS_KEY, encodedData);
  }

  Future<List<SavingsGoal>> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_SAVINGS_GOALS_KEY);
    if (encodedData == null) {
      return [];
    }
    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => SavingsGoal.fromJson(item)).toList();
  }

  Future<MonthlySummary> getCurrentMonthSummary() async {
    final token = await AppPreferences.getStringPreference('accessToken');
    final now = DateTime.now();

    try {
      final response = await dio.get(
        'transaction',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> transactions = response.data;

        double totalIncome = 0.0;
        double totalExpenses = 0.0;

        for (var transaction in transactions) {
          final amount = (transaction['amount'] ?? 0.0).toDouble();
          final isEarning = transaction['isEarning'] ?? false;
          final dateTime = DateTime.tryParse(transaction['dateTime'] ?? '');

          if (dateTime != null &&
              dateTime.year == now.year &&
              dateTime.month == now.month) {
            if (isEarning) {
              totalIncome += amount;
            } else {
              totalExpenses += amount;
            }
          }
        }

        return MonthlySummary(
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          month: _getMonthName(now.month),
          year: now.year,
        );
      } else {
        throw Exception("Error al obtener transacciones");
      }
    } catch (e) {
      debugPrint('Error obteniendo resumen mensual: $e');
      return MonthlySummary(
        totalIncome: 0.0,
        totalExpenses: 0.0,
        month: _getMonthName(now.month),
        year: now.year,
      );
    }
  }

  Future<List<CategoryExpense>> getExpensesByCategory() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      final transactionsResponse = await dio.get(
        'transaction',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final categoriesResponse = await dio.get(
        'category',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (transactionsResponse.statusCode == 200 &&
          categoriesResponse.statusCode == 200) {
        final List<dynamic> transactions = transactionsResponse.data;
        final List<dynamic> categories = categoriesResponse.data;
        final Map<String, Map<String, dynamic>> categoryMap = {};
        for (var category in categories) {
          categoryMap[category['id']] = category;
        }
        final Map<String, double> expensesByCategory = {};
        double totalExpenses = 0.0;
        final now = DateTime.now();

        for (var transaction in transactions) {
          final amount = (transaction['amount'] ?? 0.0).toDouble();
          final isEarning = transaction['isEarning'] ?? false;
          final categoryId = transaction['categoryId'] ?? '';
          final dateTime = DateTime.tryParse(transaction['dateTime'] ?? '');

          if (!isEarning &&
              dateTime != null &&
              dateTime.year == now.year &&
              dateTime.month == now.month &&
              categoryMap.containsKey(categoryId)) {
            expensesByCategory[categoryId] =
                (expensesByCategory[categoryId] ?? 0.0) + amount;
            totalExpenses += amount;
          }
        }

        List<CategoryExpense> result = [];
        expensesByCategory.forEach((categoryId, amount) {
          final category = categoryMap[categoryId];
          if (category != null) {
            final percentage = totalExpenses > 0
                ? (amount / totalExpenses) * 100
                : 0.0;
            result.add(
              CategoryExpense(
                categoryId: categoryId,
                categoryName: category['name'] ?? 'Sin nombre',
                totalAmount: amount,
                percentage: percentage,
                isEarningCategory: category['isEarningCategory'] ?? false,
              ),
            );
          }
        });

        result.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

        return result;
      } else {
        throw Exception("Error al obtener datos");
      }
    } catch (e) {
      debugPrint('Error obteniendo gastos por categoría: $e');
      return [];
    }
  }

  Future<List<MonthlyTrend>> getMonthlyTrends() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      final response = await dio.get(
        'transaction',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> transactions = response.data;
        final now = DateTime.now();

        Map<String, double> monthlyExpenses = {};

        for (int i = 5; i >= 0; i--) {
          final targetDate = DateTime(now.year, now.month - i, 1);
          final monthKey =
              '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
          monthlyExpenses[monthKey] = 0.0;
        }

        for (var transaction in transactions) {
          final amount = (transaction['amount'] ?? 0.0).toDouble();
          final isEarning = transaction['isEarning'] ?? false;
          final dateTime = DateTime.tryParse(transaction['dateTime'] ?? '');

          if (!isEarning && dateTime != null) {
            final monthKey =
                '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
            if (monthlyExpenses.containsKey(monthKey)) {
              monthlyExpenses[monthKey] = monthlyExpenses[monthKey]! + amount;
            }
          }
        }

        List<MonthlyTrend> trends = [];
        for (int i = 5; i >= 0; i--) {
          final targetDate = DateTime(now.year, now.month - i, 1);
          final monthKey =
              '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
          trends.add(
            MonthlyTrend(
              month: _getMonthName(targetDate.month),
              year: targetDate.year,
              amount: monthlyExpenses[monthKey] ?? 0.0,
            ),
          );
        }

        return trends;
      } else {
        throw Exception("Error al obtener tendencias mensuales");
      }
    } catch (e) {
      debugPrint('Error obteniendo tendencias mensuales: $e');
      return _generateDefaultTrends();
    }
  }

  Future<List<SavingsGoal>> getSavingsGoals() async {
    return await _loadGoals();
  }

  Future<SavingsGoal> createSavingsGoal({
    required String title,
    required double targetAmount,
    required String description,
    double currentAmount = 0.0,
  }) async {
    final newGoal = SavingsGoal(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), 
      title: title,
      currentAmount: currentAmount,
      targetAmount: targetAmount,
      description: description,
      createdDate: DateTime.now(),
    );

    final currentGoals = await _loadGoals();
    currentGoals.add(newGoal);
    await _saveGoals(currentGoals);

    return newGoal;
  }

  Future<SavingsGoal> updateSavingsGoal({
    required String goalId,
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? description,
  }) async {
    List<SavingsGoal> currentGoals = await _loadGoals();
    int index = currentGoals.indexWhere((goal) => goal.id == goalId);

    if (index != -1) {
      SavingsGoal oldGoal = currentGoals[index];
      SavingsGoal updatedGoal = SavingsGoal(
        id: oldGoal.id,
        title: title ?? oldGoal.title,
        currentAmount: currentAmount ?? oldGoal.currentAmount,
        targetAmount: targetAmount ?? oldGoal.targetAmount,
        description: description ?? oldGoal.description,
        createdDate: oldGoal.createdDate,
      );
      currentGoals[index] = updatedGoal;
      await _saveGoals(currentGoals);
      return updatedGoal;
    } else {
      throw Exception("Objetivo de ahorro no encontrado");
    }
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    List<SavingsGoal> currentGoals = await _loadGoals();
    currentGoals.removeWhere((goal) => goal.id == goalId);
    await _saveGoals(currentGoals);
    debugPrint('Objetivo $goalId eliminado');
  }

  List<MonthlyTrend> _generateDefaultTrends() {
    final now = DateTime.now();
    List<MonthlyTrend> trends = [];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      trends.add(
        MonthlyTrend(
          month: _getMonthName(date.month),
          year: date.year,
          amount: 1000.0 + (i * 200), 
        ),
      );
    }

    return trends;
  }

  String _getMonthName(int month) {
    if (month < 1 || month > 12) {
      debugPrint('Error: Mes fuera de rango: $month');
      return 'Mes desconocido';
    }

    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month];
  }

  Future<AnalysisData> getCompleteAnalysis() async {
    try {
      final results = await Future.wait([
        getCurrentMonthSummary(),
        getExpensesByCategory(),
        getMonthlyTrends(),
        getSavingsGoals(),
      ]);

      return AnalysisData(
        currentMonthSummary: results[0] as MonthlySummary,
        expensesByCategory: results[1] as List<CategoryExpense>,
        monthlyTrends: results[2] as List<MonthlyTrend>,
        savingsGoals: results[3] as List<SavingsGoal>,
      );
    } catch (e) {
      debugPrint('Error obteniendo análisis completo: $e');
      rethrow;
    }
  }
}
