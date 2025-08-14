import 'package:financia_mobile/models/category_model.dart';
import 'package:flutter/material.dart';

class FinanceHistoryModel {
  final String id;
  final String description;
  final double amount;
  final DateTime dateTime;
  final String categoryName;
  final String categoryId;
  final bool isEarning;
  final String? categoryIconName;
  final String? categoryColorHex;

  FinanceHistoryModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.categoryName,
    required this.categoryId,
    required this.isEarning,
    this.categoryIconName,
    this.categoryColorHex,
  });

  factory FinanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return FinanceHistoryModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      categoryName: json['categoryName'] ?? '',
      categoryId: json['categoryId'] ?? '',
      isEarning: json['isEarning'] ?? false,
      categoryIconName: json['categoryIconName'],
      categoryColorHex: json['categoryColorHex'],
    );
  }

  IconData get toIconData {
    if (categoryIconName != null) {
      return Category.getIconFromName(categoryIconName!);
    }
    return Icons.category;
  }

  Color get toColor {
    if (categoryColorHex != null) {
      return Category.getColorFromHex(categoryColorHex!);
    }
    return const Color(0xFF4A9B8E);
  }
}
