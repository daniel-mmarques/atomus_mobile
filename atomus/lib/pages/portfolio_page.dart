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
  double profitability = 0;
  ChartLevel currentLevel = ChartLevel.product;
  PortfolioProductData? selectedProduct;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PortfolioService>(context, listen: false).loadPortfolioData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolioService = context.watch<PortfolioService>();

    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      body: Stack(
        children: [
          if (portfolioService.isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3861FB)),
              ),
            )
          else if (portfolioService.hasError)
            _buildErrorState(portfolioService.errorMessage)
          else
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      _buildPortfolioContent(portfolioService),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 60,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF3861FB),
              elevation: 4,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TradePage(),
                  ),
                );
              },
              child: const Icon(
                Icons.add_rounded,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            'Erro: $errorMessage',
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioContent(PortfolioService portfolioService) {
    return Column(children: [
      _buildPortfolioSummary(portfolioService),
      const SizedBox(height: 10),
      _buildCarousel(),
    ]);
  }

  Widget _buildPortfolioSummary(PortfolioService portfolioService) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222531),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPortfolioRow('Valor da Carteira', portfolioService.totalAmount),
          _buildPortfolioRow('Rentabilidade', portfolioService.totalAmount),
          _buildPortfolioRow('Selic', portfolioService.totalAmount),
          _buildPortfolioRow('Ibovespa', portfolioService.totalAmount),
        ],
      ),
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

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 360,
          child: PageView(
            onPageChanged: (index) => setState(() => currentPageIndex = index),
            children: [
              _buildGraphContainer(_loadPieGraph()),
              _buildGraphContainer(_loadPieGraph()),
              _buildGraphContainer(_loadPieGraph()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildPageIndicator(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentPageIndex == index ? Colors.white : Colors.blueGrey,
      ),
    );
  }

  Widget _buildGraphContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222531),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }

  Widget _loadPieGraph() {
    final portfolioService = context.watch<PortfolioService>();
    if (portfolioService.totalAmount <= 0 ||
        portfolioService.portfolioData?.portfolioProductData.isEmpty == true) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Nenhum dado disponível',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 5,
          centerSpaceRadius: 90,
          sections: portfolioService.generateProductSections(touchedIndex),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse?.touchedSection == null) {
                setState(() => touchedIndex = -1);
                return;
              }
              setState(() => touchedIndex =
                  pieTouchResponse!.touchedSection!.touchedSectionIndex);
            },
          ),
        ),
      ),
    );
  }
}
