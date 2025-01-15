import 'dart:async';
import 'package:atomus/models/portfolio/portfolio_ticker_data.dart';
import 'package:dio/dio.dart';
import '../models/portfolio/portfolio_data.dart';
import '../models/portfolio/portfolio_product_data.dart';

class PortfolioRepository {
  final int _userId;
  final Dio _dio;

  PortfolioRepository(this._userId, this._dio);

  Future<PortfolioData> getPortfolio() async {
    final response = await _dio.get('/portfolio/$_userId');
    if (response.statusCode == 200) {
      return PortfolioData.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch portfolio: ${response.statusCode}');
    }
  }

  Future<PortfolioProductData> getPortfolioProduct(String product) async {
    var response = await _dio.get('/portfolio/$_userId/$product');
    if (response.statusCode == 200) {
      return PortfolioProductData.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch portfolio: ${response.statusCode}');
    }
  }

  Future<PortfolioTickerData> getPortfolioTicker() async {
    var response = await _dio.get('/portfolio/$_userId');

    if (response.statusCode == 200) {
      return PortfolioTickerData.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch portfolio: ${response.statusCode}');
    }
  }
}
