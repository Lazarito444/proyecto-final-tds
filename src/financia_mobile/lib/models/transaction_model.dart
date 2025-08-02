import 'dart:io';
import 'package:dio/dio.dart';

class TransactionModel {
  final String categoryId;
  final String description;
  final double amount;
  final DateTime dateTime;
  final bool isEarning;
  final File? imageFile;

  TransactionModel({
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.isEarning,
    this.imageFile,
  });

  Map<String, dynamic> toFormDataMap() {
    final Map<String, dynamic> data = {
      'categoryId': categoryId,
      'description': description,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'isEarning': isEarning,
    };

    if (imageFile != null) {
      data['image'] = MultipartFile.fromFileSync(
        imageFile!.path,
        filename: imageFile!.path.split('/').last,
      );
    }

    return data;
  }
}
