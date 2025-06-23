import 'dart:async';
import 'package:atomus/models/ticker/ticker_details_data.dart';
import 'package:dio/dio.dart';
import '../models/ticker/ticker_data.dart';

class SearchRepository {
  late final Dio _dio;

  SearchRepository(this._dio);

  Future<TickerDetailsData> search(String ticker) async {
    try {
      var response = await _dio.get('/search/$ticker');

      if (response.statusCode == 200) {
        return TickerDetailsData.fromJson(response.data);
      } else {
        throw Exception(
            'Erro ao carregar detalhes do ticker: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar detalhes do ticker: $e');
    }
  }

  Future<List<TickerData>> searchListByType(String type) async {
    return await _fetchTickerList('/search/list/$type');
  }

  Future<List<TickerData>> searchAllList() async {
    return await _fetchTickerList('/search/list/all');
  }

  Future<List<TickerData>> _fetchTickerList(String endpoint) async {
    try {
      var response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> tickers = response.data['stocks'];

        return tickers.map((ticker) {
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
      } else {
        throw Exception('Erro ao carregar ativos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar lista de ativos: $e');
    }
  }
}
