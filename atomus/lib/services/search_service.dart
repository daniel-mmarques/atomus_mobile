import 'package:flutter/material.dart';
import '../models/ticker/ticker_data.dart';
import '../models/ticker/ticker_details_data.dart'; // Adicionando o import para TickerDetailsData
import '../repositories/search_repository.dart';

class SearchService extends ChangeNotifier {
  final SearchRepository _repository;

  SearchService(this._repository);

  Future<List<TickerData>> getTickerList() async {
    try {
      return await _repository.searchAllList();
    } catch (error) {
      throw Exception('Failed to get ticker list: $error');
    }
  }

  Future<TickerDetailsData> getTickerDetails(String ticker) async {
    try {
      return await _repository.search(ticker);
    } catch (error) {
      throw Exception('Failed to get ticker details: $error');
    }
  }
}
