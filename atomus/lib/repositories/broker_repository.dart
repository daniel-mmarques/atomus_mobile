import 'dart:async';
import 'package:atomus/models/broker.dart';
import 'package:dio/dio.dart';

class BrokerRepository {
  final Dio _dio;

  BrokerRepository(this._dio);

  Future<List<Broker>> getAll() async {
    try {
      var response = await _dio.get('/corretora');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Broker.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar corretoras: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar corretoras: $e');
    }
  }
}
