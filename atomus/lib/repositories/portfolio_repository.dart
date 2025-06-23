import 'dart:async';
import 'package:atomus/models/portfolio/portfolio_data.dart';
import 'package:atomus/models/portfolio/portfolio_ticker_data.dart';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import '../models/portfolio/portfolio_product_data.dart';

class PortfolioRepository {
  final int _userId;
  final Dio _dio;

  PortfolioRepository(this._userId, this._dio);

  Future<PortfolioData> getPortfolio() async {
    try {
      return await retry(
        () async {
          var response = await _dio.get('/portfolio/$_userId');
          return PortfolioData.fromJson(response.data);
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
      );
    } catch (e) {
      throw Exception('Erro ao buscar o portfólio: $e');
    }
  }

  Future<PortfolioProductData> getPortfolioProduct(String product) async {
    try {
      return await retry(
        () async {
          var response = await _dio.get('/portfolio/$_userId/$product');
          return PortfolioProductData.fromJson(response.data);
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
      );
    } catch (e) {
      throw Exception('Erro ao buscar o portfólio do produto "$product": $e');
    }
  }

  Future<PortfolioTickerData> getPortfolioTicker() async {
    try {
      return await retry(
        () async {
          var response = await _dio.get('/portfolio/$_userId');
          return PortfolioTickerData.fromJson(response.data);
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
      );
    } catch (e) {
      throw Exception('Erro ao buscar o portfólio de tickers: $e');
    }
  }
}
