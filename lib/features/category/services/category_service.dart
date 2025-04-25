import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/category/model/category_model.dart';

class CategoryService {
  final dio = Dio();
  final url = 'http://10.0.2.2:5231/api/Category';
  final StorageService _storageService = StorageService();

  Future<Options> getHeaders() async {
    final token = await _storageService.getToken();

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<Category>> fetchCategories() async {
    List<Category> categories = [];
    final response = await dio.get(
      "$url/categories",
      options: await getHeaders(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final responseData = response.data as List;
      categories =
          responseData.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Anket detayları yüklenemedi");
    }

    return categories;
  }

  Future<void> addCategory(String name) async {
    final res = "$url/categories";
    try {
      final response = await dio.post(
        res,
        data: {"name": name},
        options: await getHeaders(),
      );
      if (response.statusCode == 200) {
        log('Anket başarıyla oluşturuldu.');
      } else {
        log('Beklenmeyen hata: ${response.statusCode}');
        log('Detay: ${response.data}');
      }
    } catch (e) {
      log('POST işlemi sırasında hata oluştu: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    final res = "$url/categories/$id";
    try {
      final response = await dio.delete(res, options: await getHeaders());
      if (response.statusCode == 200) {
        log('Kategori başarıyla silindi.');
      } else {
        log('Silme hatası: ${response.statusCode}');
        log('Detay: ${response.data}');
      }
    } catch (e) {
      log('DELETE işlemi sırasında hata oluştu: $e');
    }
  }

  Future<void> updateCategory(int id, String newName) async {
    final res = "$url/categories/$id";
    try {
      final response = await dio.put(
        res,
        data: {"id": id, "name": newName},
        options: await getHeaders(),
      );
      if (response.statusCode == 200) {
        log('Kategori başarıyla güncellendi.');
      } else {
        log('Güncelleme hatası: ${response.statusCode}');
        log('Detay: ${response.data}');
      }
    } catch (e) {
      log('PUT işlemi sırasında hata oluştu: $e');
    }
  }
}
