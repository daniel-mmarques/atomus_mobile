import 'dart:async';
import 'package:atomus/models/ticker/ticker_details_data.dart';
import 'package:dio/dio.dart';

import '../models/ticker/ticker_data.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  Future<TickerDetailsData> search(String ticker) async {
    var response = await _dio.get('/search/$ticker');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = response.data;
      final TickerDetailsData tickerDetails = TickerDetailsData.fromJson(json);
      return tickerDetails;
    } else {
      throw Exception('Failed to load ticker details: ${response.statusCode}');
    }
  }

  Future<List<TickerData>> searchListByType(String type) async {
    var response = await _dio.get('/search/list/$type');

    if (response.statusCode == 200) {
      final json = response.data;
      final List<dynamic> tickers = json['stocks'];

      List<TickerData> tickerList = tickers.map((ticker) {
        return TickerData(
          stock: ticker['stock'],
          name: ticker['name'],
          close: ticker['close'],
          change: ticker['change'],
          volume: ticker['volume'],
          marketCap: ticker['marketCap'],
          logo: ticker['logo'],
          sector: ticker['sector'] ?? '',
          type: ticker['type'],
        );
      }).toList();

      return tickerList;
    } else {
      throw Exception('Failed to load ativos: ${response.statusCode}');
    }
  }

  Future<List<TickerData>> searchAllList() async {
    var response = await _dio.get('/search/list/all');

    if (response.statusCode == 200) {
      final json = response.data;
      final List<dynamic> tickers = json['stocks'];

      List<TickerData> tickerList = tickers.map((ticker) {
        return TickerData(
          stock: ticker['stock'],
          name: ticker['name'],
          close: ticker['close'],
          change: ticker['change'],
          volume: ticker['volume'],
          marketCap: ticker['marketCap'],
          logo: ticker['logo'],
          sector: ticker['sector'] ?? '',
          type: ticker['type'],
        );
      }).toList();

      return tickerList;
    } else {
      throw Exception('Failed to load ativos: ${response.statusCode}');
    }
  }
}
