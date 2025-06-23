import 'dart:async';
import 'package:dio/dio.dart';
import '../models/trade.dart';

class TradeRepository {
  final int _userId;
  final Dio _dio;

  TradeRepository(this._userId, this._dio);

  Future<Trade> save(Trade trade) async {
    try {
      final Map<String, dynamic> tradeBody = {
        "userId": _userId,
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
        return Trade.fromJson(response.data);
      } else {
        throw Exception('Erro ao salvar negociação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao salvar negociação: $e');
    }
  }

  Future<void> delete(int tradeId) async {
    try {
      var response = await _dio.delete('/negociacao/$tradeId');

      if (response.statusCode != 204) {
        throw Exception('Erro ao deletar negociação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar negociação: $e');
    }
  }

  Future<List<Trade>> getHistorico() async {
    return await _fetchTradeList('/negociacao/$_userId');
  }

  Future<List<Trade>> getHistoricoProduto(String produto) async {
    return await _fetchTradeList('/negociacao/$_userId/$produto');
  }

  Future<List<Trade>> getHistoricoTitulo(String produto, String ticker) async {
    return await _fetchTradeList('/negociacao/$_userId/$produto/$ticker');
  }

  Future<List<Trade>> _fetchTradeList(String endpoint) async {
    try {
      var response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Trade.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao carregar histórico de negociações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar histórico de negociações: $e');
    }
  }
}
