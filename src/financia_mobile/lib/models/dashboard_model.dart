import 'package:flutter/material.dart';

class DashboardData {
  final List<Transaction> userLastTransactions;
  final double earnings;
  final double expenses;
  final List<CategorySummary> earningsByCategory;
  final List<CategorySummary> expensesByCategory;

  DashboardData({
    required this.userLastTransactions,
    required this.earnings,
    required this.expenses,
    required this.earningsByCategory,
    required this.expensesByCategory,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionsJson = json['userLastTransactions'] ?? [];
    final userLastTransactions = transactionsJson
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
    final List<dynamic> earningsByCategoryJson =
        json['earningsByCategory'] ?? [];
    final earningsByCategory = earningsByCategoryJson
        .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
        .toList();
    final List<dynamic> expensesByCategoryJson =
        json['expensesByCategory'] ?? [];
    final expensesByCategory = expensesByCategoryJson
        .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardData(
      userLastTransactions: userLastTransactions,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0.0,
      earningsByCategory: earningsByCategory,
      expensesByCategory: expensesByCategory,
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final String description;
  final String categoryName;
  final DateTime dateTime;
  final bool isEarningCategory;
  final String colorHex;
  final String iconName;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.categoryName,
    required this.dateTime,
    required this.isEarningCategory,
    required this.colorHex,
    required this.iconName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      categoryName: json['categoryName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      isEarningCategory: json['isEarningCategory'] as bool,
      colorHex: json['colorHex'] as String,
      iconName: json['iconName'] as String,
    );
  }

  IconData get toIconData {
    switch (iconName) {
      case 'Salary':
        return Icons.attach_money;
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'Extra':
        return Icons.attach_money;
      default:
        return Icons.money;
    }
  }

  Color get toColor {
    String hexColor = colorHex.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class CategorySummary {
  final String categoryName;
  final double totalAmount;

  CategorySummary({required this.categoryName, required this.totalAmount});

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      categoryName: json['categoryName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
