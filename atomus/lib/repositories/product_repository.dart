import 'dart:async';

import 'package:atomus/models/product.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<Product>> getAll() async {
    var response = await _dio.get('/produto');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trade history: ${response.statusCode}');
    }
  }
}
