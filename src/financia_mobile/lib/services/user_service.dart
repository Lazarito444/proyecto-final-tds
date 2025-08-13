import 'dart:io';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:financia_mobile/models/user_model.dart';
import 'package:financia_mobile/config/app_preferences.dart';

class UserService {
  late final Dio _dio;

  UserService() {
    _dio = DioFactory.createDio();
  }

  Future<User?> getCurrentUser() async {
    try {
      // Get current user ID from preferences
      final userId = await AppPreferences.getStringPreference('user_id');
      if (userId == null) return null;

      final response = await _dio.get('/account/$userId');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Error getting current user: ${e.message}');
      return null;
    }
  }

  Future<User?> updateUser(String userId, UpdateUserRequest request) async {
    try {
      FormData formData = FormData();

      if (request.fullName != null) {
        formData.fields.add(MapEntry('FullName', request.fullName!));
      }

      if (request.dateOfBirth != null) {
        // Convert DateTime to DateOnly format (YYYY-MM-DD)
        final dateOnly = request.dateOfBirth!.toIso8601String().split('T')[0];
        formData.fields.add(MapEntry('DateOfBirth', dateOnly));
      }

      if (request.gender != null) {
        formData.fields.add(
          MapEntry('Gender', request.gender!.value.toString()),
        );
      }

      if (request.password != null && request.currentPassword != null) {
        formData.fields.add(MapEntry('Password', request.password!));
        formData.fields.add(
          MapEntry('CurrentPassword', request.currentPassword!),
        );
      }

      if (request.photoFile != null) {
        formData.files.add(
          MapEntry(
            'PhotoFile',
            await MultipartFile.fromFile(
              request.photoFile!.path,
              filename: request.photoFile!.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.put('/account/$userId', data: formData);

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Error updating user: ${e.message}');
      throw Exception(
        'Error al actualizar los datos: ${e.response?.data?['message'] ?? e.message}',
      );
    }
  }

  Future<void> saveUserIdLocally(String userId) async {
    await AppPreferences.setStringPreference('user_id', userId);
  }

  Future<String?> getUserIdLocally() async {
    return await AppPreferences.getStringPreference('user_id');
  }
}
