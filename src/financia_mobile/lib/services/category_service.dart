import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:financia_mobile/models/category_model.dart';
import 'package:financia_mobile/config/dio_factory.dart';

class CategoryService {
  late final Dio _dio;

  CategoryService() {
    _dio = DioFactory.createDio();
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/category');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<Category> getCategoryById(String id) async {
    try {
      final response = await _dio.get('/category/$id');
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Category not found');
      }
      throw Exception('Error fetching category: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<Category> createCategory(CreateCategoryDto categoryDto) async {
    try {
      final response = await _dio.post('/category', data: categoryDto.toJson());
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to create category: $errorMessage');
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  Future<Category> updateCategory(
    String id,
    CreateCategoryDto categoryDto,
  ) async {
    try {
      final response = await _dio.put(
        '/category/$id',
        data: categoryDto.toJson(),
      );
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Category not found');
      }
      throw Exception('Error updating category: ${e.message}');
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete('/category/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Category not found');
      }
      throw Exception('Error deleting category: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  // Helper method to get icon name from IconData
  static String getIconNameFromIconData(IconData iconData) {
    switch (iconData.codePoint) {
      case 0xe57f: // Icons.restaurant
        return 'restaurant';
      case 0xe1ca: // Icons.directions_car
        return 'directions_car';
      case 0xe405: // Icons.movie
        return 'movie';
      case 0xe227: // Icons.attach_money
        return 'attach_money';
      case 0xe8f9: // Icons.work
        return 'work';
      case 0xe88a: // Icons.home
        return 'home';
      case 0xe59c: // Icons.shopping_cart
        return 'shopping_cart';
      case 0xe571: // Icons.local_gas_station
        return 'local_gas_station';
      case 0xe80c: // Icons.school
        return 'school';
      case 0xe57e: // Icons.medical_services
        return 'medical_services';
      default:
        return 'category';
    }
  }

  // Helper method to get hex color from Color
  static String getHexFromColor(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
