import 'package:atomus/models/portfolio/portfolio_product_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/portfolio/portfolio_data.dart';
import '../repositories/portfolio_repository.dart';

class PortfolioService extends ChangeNotifier {
  final PortfolioRepository portfolioRepository;

  PortfolioService(this.portfolioRepository);

  PortfolioData? portfolioData;
  double totalAmount = 0.0;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  Future<void> loadPortfolioData() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final data = await portfolioRepository.getPortfolio();
      portfolioData = data;
      totalAmount = data.totalAmount;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  static const List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  Color _getColor(int index) => _colors[index % _colors.length];

  List<PieChartSectionData> _generateSections(
      List<dynamic> dataList, int? touchedIndex, double total) {
    if (dataList.isEmpty || total <= 0) return [];

    return List.generate(dataList.length, (i) {
      final data = dataList[i];
      final percentage = (data.totalAmount / total) * 100;
      final isTouched = touchedIndex != null && touchedIndex == i;

      return PieChartSectionData(
        color: _getColor(i),
        value: percentage,
        title: '${percentage.floor()}%',
        radius: isTouched ? 65.0 : 55.0,
        titleStyle: TextStyle(
          fontSize: isTouched ? 18.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }

  List<PieChartSectionData> generateProductSections(int? touchedIndex) {
    if (portfolioData?.portfolioProductData == null) return [];
    return _generateSections(
        portfolioData!.portfolioProductData, touchedIndex, totalAmount);
  }

  List<PieChartSectionData> generateTickerSections(
      int? touchedIndex, PortfolioProductData? product) {
    if (product == null || product.portfolioTickerData.isEmpty) return [];
    return _generateSections(
        product.portfolioTickerData, touchedIndex, product.totalAmount);
  }
}
