import 'package:atomus/models/portfolio/portfolio_product_data.dart';
import 'package:atomus/pages/trade_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

enum ChartLevel { product, ticker }

class _PortfolioPageState extends State<PortfolioPage> {
  int touchedIndex = -1;
  String ticker = '';
  double value = 0;
  double profiability = 0;
  ChartLevel currentLevel = ChartLevel.product;
  PortfolioProductData? selectedProduct;

  @override
  void initState() {
    super.initState();
    final portfolioService =
        Provider.of<PortfolioService>(context, listen: false);
    portfolioService.loadPortfolioData();
  }

  @override
  Widget build(BuildContext context) {
    final portfolioService = context.watch<PortfolioService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: portfolioService.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCFF00))))
          : portfolioService.hasError
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        'Erro: ${portfolioService.errorMessage}',
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30, left: 6, right: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPortfolioRow('Valor da Carteira',
                                portfolioService.totalAmount),
                            _buildPortfolioRow(
                                'Rentabilidade', portfolioService.totalAmount),
                            _buildPortfolioRow(
                                'Selic', portfolioService.totalAmount),
                            _buildPortfolioRow(
                                'Ibovespa', portfolioService.totalAmount),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: loadPieGrafic(),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: loadTradeButton(),
    );
  }

  Widget _buildPortfolioRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        Text(
          'R\$ ${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  loadPieGrafic() {
    final portfolioService = context.watch<PortfolioService>();
    return portfolioService.totalAmount <= 0 ||
            portfolioService.portfolioData?.portfolioProductData.isEmpty == true
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: Text(
                'Nenhum dado disponível',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      sectionsSpace: 5,
                      centerSpaceRadius: 110,
                      sections: currentLevel == ChartLevel.product
                          ? portfolioService
                              .generateProductSections(touchedIndex)
                          : portfolioService.generateTickerSections(
                              touchedIndex, selectedProduct),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            print('Touched index: $touchedIndex');

                            if (event is FlTapUpEvent) {
                              if (currentLevel == ChartLevel.product) {
                                selectedProduct = portfolioService
                                    .portfolioData!
                                    .portfolioProductData[touchedIndex];
                                currentLevel = ChartLevel.ticker;
                              } else {
                                currentLevel = ChartLevel.product;
                                selectedProduct = null;
                              }
                              print('Current Level: $currentLevel');
                            }
                          });
                        },
                      )),
                ),
              ),
              if (currentLevel == ChartLevel.ticker)
                Column(
                  children: [
                    Text(
                      selectedProduct?.product ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      value.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Text(
                      profiability.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )
            ],
          );
  }

  loadTradeButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFCCFF00),
      child: const Icon(Icons.add, color: Colors.black),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TradePage(),
          ),
        );
      },
    );
  }
}
