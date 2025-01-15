import 'portfolio_ticker_data.dart';

class PortfolioProductData {
  final String product;
  final double totalAmount;
  final List<PortfolioTickerData> portfolioTickerData;

  PortfolioProductData({
    required this.product,
    required this.totalAmount,
    required this.portfolioTickerData,
  });

  factory PortfolioProductData.fromJson(Map<String, dynamic> json) {
    return PortfolioProductData(
      product: json['product'],
      totalAmount: json['totalAmount'],
      portfolioTickerData: (json['portfolioTickerData'] as List)
          .map((item) => PortfolioTickerData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'totalAmount': totalAmount,
      'portfolioTickerData':
          portfolioTickerData.map((item) => item.toJson()).toList(),
    };
  }
}
