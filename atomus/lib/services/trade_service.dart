import 'package:atomus/repositories/trade_repository.dart';
import 'package:atomus/models/trade.dart';
import 'package:flutter/material.dart';

class TradeService extends ChangeNotifier {
  final TradeRepository tradeRepository;

  List<Trade> trades = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  TradeService(this.tradeRepository);

  Future<void> loadTrades() async {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();

      trades = await tradeRepository.getHistorico();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTradesByProduct(String product) async {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();

      trades = await tradeRepository.getHistoricoProduto(product);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTradesByTicker(String product, String ticker) async {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();

      trades = await tradeRepository.getHistoricoTitulo(product, ticker);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTrade(int tradeId) async {
    try {
      await tradeRepository.delete(tradeId);
      trades.removeWhere((trade) => trade.id == tradeId);
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void loadTradesAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadTrades();
    });
  }
}
