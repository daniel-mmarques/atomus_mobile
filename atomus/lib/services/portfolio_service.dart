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
    try {
      isLoading = true;
      hasError = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      portfolioData = await portfolioRepository.getPortfolio();
      totalAmount = portfolioData!.totalAmount;

      isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();

      isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Color _getColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];
    return colors[index % colors.length];
  }

  List<PieChartSectionData> generateProductSections(int? touchedIndex) {
    List<PortfolioProductData> products = portfolioData!.portfolioProductData;
    if (products.isEmpty || totalAmount <= 0) return [];

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final percentage = product.totalAmount / totalAmount * 100;
      final isTouched = touchedIndex != null && touchedIndex == i;

      sections.add(PieChartSectionData(
        color: _getColor(i),
        value: percentage,
        title: '${percentage.floor()}%',
        radius: isTouched ? 65.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: isTouched ? 20.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
    }

    return sections;
  }

  List<PieChartSectionData> generateTickerSections(
      int? touchedIndex, PortfolioProductData? product) {
    if (product == null || product.portfolioTickerData.isEmpty) return [];

    List<PieChartSectionData> sections = [];
    final total = product.totalAmount;

    for (int i = 0; i < product.portfolioTickerData.length; i++) {
      final ticker = product.portfolioTickerData[i];
      final percentage = ticker.totalAmount / total * 100;
      final isTouched = touchedIndex != null && touchedIndex == i;

      sections.add(PieChartSectionData(
        color: _getColor(i),
        value: percentage,
        title: '${percentage.floor()}%',
        radius: isTouched ? 65.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: isTouched ? 20.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
    }

    return sections;
  }
}
