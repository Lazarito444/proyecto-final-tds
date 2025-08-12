import 'package:flutter/material.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  final bool isEarningCategory;
  final String colorHex;
  final String iconName;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.isEarningCategory,
    required this.colorHex,
    required this.iconName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      isEarningCategory: json['isEarningCategory'] as bool,
      colorHex: json['colorHex'] as String,
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'isEarningCategory': isEarningCategory,
      'colorHex': colorHex,
      'iconName': iconName,
    };
  }

  // Helper method to convert to the format expected by the UI
  Map<String, dynamic> toUIFormat() {
    return {
      'id': id,
      'name': name,
      'icon': getIconFromName(iconName),
      'color': getColorFromHex(colorHex),
      'type': isEarningCategory ? 'income' : 'expense',
    };
  }

  // Helper method to get IconData from icon name
  static IconData getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'movie':
        return Icons.movie;
      case 'attach_money':
        return Icons.attach_money;
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'school':
        return Icons.school;
      case 'medical_services':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }

  // Helper method to get Color from hex string
  static Color getColorFromHex(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF000000);
    }
  }
}

class CreateCategoryDto {
  final String name;
  final bool isEarningCategory;
  final String colorHex;
  final String iconName;

  CreateCategoryDto({
    required this.name,
    required this.isEarningCategory,
    required this.colorHex,
    required this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isEarningCategory': isEarningCategory,
      'colorHex': colorHex,
      'iconName': iconName,
    };
  }
}
