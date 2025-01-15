import 'dart:async';

import 'package:dio/dio.dart';

import '../models/trade.dart';

class TradeRepository {
  final int _userId;
  final Dio _dio;

  TradeRepository(this._userId, this._dio);

  Future<Trade> save(Trade trade) async {
    final Map<String, dynamic> tradeBody = {
      "userId": trade.userId,
      "tradeType": trade.tradeType,
      "tradeDate": trade.tradeDate.toIso8601String(),
      "brokerId": trade.brokerId,
      "productId": trade.productId,
      "title": trade.title,
      "quantity": trade.quantity,
      "unitPrice": trade.unitPrice,
      "fees": trade.fees,
    };

    var response = await _dio.post('/negociacao', data: tradeBody);

    if (response.statusCode == 201) {
      final Map<String, dynamic> json = response.data;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to save this trade: ${response.statusCode}');
    }
  }

  Future delete(int tradeId) async {
    var response = await _dio.delete('/negociacao/$tradeId');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete this trade: ${response.statusCode}');
    }
    return response.headers;
  }

  Future<List<Trade>> getHistorico() async {
    var response = await _dio.get('/negociacao/$_userId');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Trade.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trade history: ${response.statusCode}');
    }
  }

  Future<List<Trade>> getHistoricoProduto(String produto) async {
    var response = await _dio.get('/negociacao/$_userId/$produto');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Trade.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trade history: ${response.statusCode}');
    }
  }

  Future<List<Trade>> getHistoricoTitulo(String produto, String ticker) async {
    var response = await _dio.get('/negociacao/$_userId/$produto/$ticker');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Trade.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trade history: ${response.statusCode}');
    }
  }
}
