import 'dart:io';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:financia_mobile/models/transaction_model.dart';

class TransactionService {
  final Dio dio = DioFactory.createDio();

  Future<void> createTransaction(TransactionModel transaction) async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      final formData = FormData.fromMap({
        'categoryId': transaction.categoryId,
        'description': transaction.description,
        'amount': transaction.amount,
        'dateTime': transaction.dateTime.toIso8601String(),
        'isEarning': transaction.isEarning,
        if (transaction.imageFile != null)
          'image': await MultipartFile.fromFile(
            transaction.imageFile!.path,
            filename: transaction.imageFile!.path.split('/').last,
          ),
      });

      final response = await dio.post(
        'transaction',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          "Error al crear transacción: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Error al crear transacción: ${e.message}");
    }
  }
}
