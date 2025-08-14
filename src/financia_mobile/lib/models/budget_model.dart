class Budget {
  final String id;
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final double maximumAmount;

  Budget({
    required this.id,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    required this.maximumAmount,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isRecurring: json['isRecurring'] as bool,
      maximumAmount: (json['maximumAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isRecurring': isRecurring,
      'maximumAmount': maximumAmount,
    };
  }

  // Helper method to get period string based on date range
  String get period {
    final difference = endDate.difference(startDate).inDays;
    if (difference <= 7) {
      return 'Semanal';
    } else if (difference <= 31) {
      return 'Mensual';
    } else {
      return 'Anual';
    }
  }

  // Helper method to check if budget is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}

class CreateBudgetDto {
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final double maximumAmount;

  CreateBudgetDto({
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    required this.maximumAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isRecurring': isRecurring,
      'maximumAmount': maximumAmount,
    };
  }
}

class UpdateBudgetDto {
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final double maximumAmount;

  UpdateBudgetDto({
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    required this.maximumAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isRecurring': isRecurring,
      'maximumAmount': maximumAmount,
    };
  }
}
