import 'dart:math';
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
    switch (categoryName.toLowerCase()) {
      case 'salary':
        return Icons.attach_money;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'extra':
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

class CircleBorderPainter extends CustomPainter {
  final double earnings;
  final double expenses;
  final Color incomeColor;
  final Color expenseColor;
  final Color borderColor;
  final double strokeWidth;

  CircleBorderPainter({
    required this.earnings,
    required this.expenses,
    required this.incomeColor,
    required this.expenseColor,
    required this.borderColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final total = earnings.abs() + expenses.abs();

    if (total == 0) {
      paint.color = borderColor;
      canvas.drawCircle(center, radius, paint);
    } else {
      final incomeSweepAngle = (earnings.abs() / total) * 2 * pi;
      final expenseSweepAngle = (expenses.abs() / total) * 2 * pi;

      paint.color = incomeColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        incomeSweepAngle,
        false,
        paint,
      );

      paint.color = expenseColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + incomeSweepAngle,
        expenseSweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircleBorderPainter oldDelegate) {
    return oldDelegate.earnings != earnings ||
        oldDelegate.expenses != expenses ||
        oldDelegate.incomeColor != incomeColor ||
        oldDelegate.expenseColor != expenseColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
