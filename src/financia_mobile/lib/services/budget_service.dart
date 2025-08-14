import 'package:dio/dio.dart';
import 'package:financia_mobile/models/budget_model.dart';
import 'package:financia_mobile/models/category_model.dart';
import 'package:financia_mobile/config/dio_factory.dart';

class BudgetService {
  late final Dio _dio;

  BudgetService() {
    _dio = DioFactory.createDio();
  }

  // Get all categories (needed for budget creation)
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/category');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get all budgets
  Future<List<Budget>> getAllBudgets() async {
    try {
      final response = await _dio.get('/bugdet');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Budget.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error fetching budgets: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching budgets: $e');
    }
  }

  // Get budget by ID
  Future<Budget> getBudgetById(String id) async {
    try {
      final response = await _dio.get('/bugdet/$id');
      return Budget.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Budget not found');
      }
      throw Exception('Error fetching budget: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching budget: $e');
    }
  }

  // Create new budget
  Future<Budget> createBudget(CreateBudgetDto budgetDto) async {
    try {
      final response = await _dio.post('/bugdet', data: budgetDto.toJson());
      return Budget.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to create budget: $errorMessage');
    } catch (e) {
      throw Exception('Error creating budget: $e');
    }
  }

  // Update existing budget
  Future<Budget> updateBudget(String id, UpdateBudgetDto budgetDto) async {
    try {
      final response = await _dio.put('/bugdet/$id', data: budgetDto.toJson());
      return Budget.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Budget not found');
      }
      throw Exception('Error updating budget: ${e.message}');
    } catch (e) {
      throw Exception('Error updating budget: $e');
    }
  }

  // Delete budget
  Future<void> deleteBudget(String id) async {
    try {
      await _dio.delete('/bugdet/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Budget not found');
      }
      throw Exception('Error deleting budget: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting budget: $e');
    }
  }

  // Método para obtener gastos de una categoría en un período específico
  Future<double> getSpentAmountByCategory({
    required String categoryId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final response = await _dio.get(
        '/transaction/filter',
        queryParameters: {
          'CategoryId': categoryId,
          'Earning': false, // Solo gastos (no ingresos)
          'FromDate': fromDate.toIso8601String(),
          'ToDate': toDate.toIso8601String(),
        },
      );

      final List<dynamic> transactions = response.data;
      double totalSpent = 0.0;

      // Sumar todos los gastos de la categoría
      for (var transaction in transactions) {
        final amount = (transaction['amount'] as num).toDouble();
        totalSpent += amount
            .abs(); // Usar valor absoluto por si vienen negativos
      }

      return totalSpent;
    } catch (e) {
      // Si hay error, devolver 0 para no romper la UI
      return 0.0;
    }
  }

  // Método para obtener presupuestos con gastos calculados
  Future<List<BudgetWithSpent>> getBudgetsWithSpentAmounts() async {
    try {
      final budgets = await getAllBudgets();
      final List<BudgetWithSpent> budgetsWithSpent = [];

      // Calcular gastos para cada presupuesto
      for (var budget in budgets) {
        final spentAmount = await getSpentAmountByCategory(
          categoryId: budget.categoryId,
          fromDate: budget.startDate,
          toDate: budget.endDate,
        );

        budgetsWithSpent.add(
          BudgetWithSpent(budget: budget, spentAmount: spentAmount),
        );
      }

      return budgetsWithSpent;
    } catch (e) {
      throw Exception('Error getting budgets with spent amounts: $e');
    }
  }

  // Helper method to calculate period dates based on period type
  static Map<String, DateTime> calculatePeriodDates(String period) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (period) {
      case 'Semanal':
        // Start of current week (Monday)
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'Mensual':
        // Start of current month
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case 'Anual':
        // Start of current year
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
      default:
        // Default to monthly
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
    }

    return {'startDate': startDate, 'endDate': endDate};
  }
}

// Nueva clase para presupuesto con gasto calculado
class BudgetWithSpent {
  final Budget budget;
  final double spentAmount;

  BudgetWithSpent({required this.budget, required this.spentAmount});

  // Propiedades calculadas
  double get remainingAmount => budget.maximumAmount - spentAmount;
  double get progress =>
      budget.maximumAmount > 0 ? spentAmount / budget.maximumAmount : 0.0;
  bool get isOverBudget => spentAmount > budget.maximumAmount;
}
