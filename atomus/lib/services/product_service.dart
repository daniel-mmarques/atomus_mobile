import 'package:atomus/models/product.dart';
import 'package:atomus/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductService extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductService(this._productRepository);

  Future<List<Product>> getAll() async {
    return _productRepository.getAll();
  }
}
