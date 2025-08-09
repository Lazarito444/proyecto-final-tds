import 'package:flutter/material.dart';
import 'package:financia_mobile/generated/l10n.dart';

String _getTranslatedMonthName(BuildContext context, String month) {
  switch (month) {
    case 'Enero':
      return S.of(context).january;
    case 'Febrero':
      return S.of(context).february;
    case 'Marzo':
      return S.of(context).march;
    case 'Abril':
      return S.of(context).april;
    case 'Mayo':
      return S.of(context).may;
    case 'Junio':
      return S.of(context).june;
    case 'Julio':
      return S.of(context).july;
    case 'Agosto':
      return S.of(context).august;
    case 'Septiembre':
      return S.of(context).september;
    case 'Octubre':
      return S.of(context).october;
    case 'Noviembre':
      return S.of(context).november;
    case 'Diciembre':
      return S.of(context).december;
    default:
      return month;
  }
}

class MonthlySummary {
  final double totalIncome;
  final double totalExpenses;
  final String month;
  final int year;

  MonthlySummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.month,
    required this.year,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      totalIncome: (json['totalIncome'] ?? 0.0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0.0).toDouble(),
      month: json['month'] ?? '',
      year: json['year'] ?? DateTime.now().year,
    );
  }

  String getTranslatedMonthName(BuildContext context) {
    return _getTranslatedMonthName(context, month);
  }

  double get balance => totalIncome - totalExpenses;
}

class CategoryExpense {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final double percentage;
  final bool isEarningCategory;

  CategoryExpense({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
    required this.isEarningCategory,
  });

  factory CategoryExpense.fromJson(Map<String, dynamic> json) {
    return CategoryExpense(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      isEarningCategory: json['isEarningCategory'] ?? false,
    );
  }
}

class MonthlyTrend {
  final String month;
  final int year;
  final double amount;

  MonthlyTrend({required this.month, required this.year, required this.amount});

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) {
    return MonthlyTrend(
      month: json['month'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      amount: (json['amount'] ?? 0.0).toDouble(),
    );
  }

  String getTranslatedMonthName(BuildContext context) {    
    return _getTranslatedMonthName(context, month);
  }
}

class SavingsGoal {
  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String description;
  final DateTime createdDate;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.description,
    required this.createdDate,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      createdDate:
          DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;
  int get progressPercentage => (progress * 100).round();
}

class AnalysisData {
  final MonthlySummary currentMonthSummary;
  final List<CategoryExpense> expensesByCategory;
  final List<MonthlyTrend> monthlyTrends;
  final List<SavingsGoal> savingsGoals;

  AnalysisData({
    required this.currentMonthSummary,
    required this.expensesByCategory,
    required this.monthlyTrends,
    required this.savingsGoals,
  });
}
