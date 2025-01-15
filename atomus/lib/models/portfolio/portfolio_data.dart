import 'portfolio_product_data.dart';

class PortfolioData {
  final int userId;
  final double totalAmount;
  final List<PortfolioProductData> portfolioProductData;

  PortfolioData({
    required this.userId,
    required this.totalAmount,
    required this.portfolioProductData,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      userId: json['userId'],
      totalAmount: json['totalAmount'],
      portfolioProductData: (json['portfolioProductData'] as List)
          .map((item) => PortfolioProductData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'portfolioProductData':
          portfolioProductData.map((item) => item.toJson()).toList(),
    };
  }
}
