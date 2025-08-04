class FinanceHistoryModel {
  final String id;
  final String description;
  final double amount;
  final DateTime dateTime;
  final bool isEarning;
  final String categoryName;
  final String categoryIconName;

  FinanceHistoryModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.isEarning,
    required this.categoryName,
    required this.categoryIconName,
  });

  factory FinanceHistoryModel.fromJson(Map<String, dynamic> json, Map<String, dynamic> categoryJson) {
    return FinanceHistoryModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: json['amount'] as double,
      dateTime: DateTime.parse(json['dateTime'] as String),
      isEarning: json['isEarning'] as bool,
      categoryName: categoryJson['name'] as String,
      categoryIconName: categoryJson['iconName'] as String,
    );
  }
}