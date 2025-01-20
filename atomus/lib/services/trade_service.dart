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

      trades = await tradeRepository.getHistorico();
      isLoading = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadTradesByProduct(String product) async {
    try {
      isLoading = true;
      hasError = false;

      trades = await tradeRepository.getHistoricoProduto(product);
      isLoading = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadTradesByTicker(String product, String ticker) async {
    try {
      isLoading = true;
      hasError = false;

      trades = await tradeRepository.getHistoricoTitulo(product, ticker);
      isLoading = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      isLoading = false;
    } finally {
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

  Future<void> saveTrade({
    required String tradeType,
    required DateTime tradeDate,
    required int brokerId,
    required int productId,
    required String title,
    required int quantity,
    required double unitPrice,
    required double fees,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('A quantidade deve ser maior que zero.');
    }
    if (unitPrice < 0 || fees < 0) {
      throw ArgumentError('Preço unitário e taxas não podem ser negativos.');
    }

    try {
      final trade = Trade(
        userId: 7,
        tradeType: tradeType,
        tradeDate: tradeDate,
        brokerId: brokerId,
        productId: productId,
        title: title,
        quantity: quantity,
        unitPrice: unitPrice,
        fees: fees,
      );

      await tradeRepository.save(trade);
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Erro ao salvar trade: $e\n$stackTrace');
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void loadTradesAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadTrades();
    });
  }
}
