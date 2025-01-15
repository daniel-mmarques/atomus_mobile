import 'dart:math';

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

  Color _generateColor() {
    double saturation = 0.8;
    double lightness = 0.4;

    Random random = Random();
    double hue = random.nextDouble() * 360;

    HSLColor hslColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
    Color rgbColor = hslColor.toColor();

    return rgbColor;
  }

  List<PieChartSectionData> generatePieChartSections(int? touchedIndex) {
    List<PortfolioProductData> products = portfolioData!.portfolioProductData;
    if (products.isEmpty || totalAmount <= 0) return [];

    List<PieChartSectionData> sections = [];

    for (var product in products) {
      for (var ticker in product.portfolioTickerData) {
        final percentage = ticker.totalAmount / totalAmount * 100;
        final isTouched =
            touchedIndex != null && touchedIndex == sections.length;

        sections.add(PieChartSectionData(
          color: _generateColor(),
          value: percentage,
          title: '${percentage.floor().toString()}%',
          radius: isTouched ? 70.0 : 55.0,
          titleStyle: TextStyle(
            fontSize: isTouched ? 22.0 : 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
      }
    }

    return sections;
  }
}
