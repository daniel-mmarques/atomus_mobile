import 'package:fl_chart/fl_chart.dart';

import '../models/ticker/ticker_data.dart';
import 'package:flutter/material.dart';

class TickerSquareCard extends StatelessWidget {
  final TickerData tickerData;
  final List<TickerData> favoritadas;
  final void Function(TickerData tickerData) mostrarDetalhes;
  final void Function(TickerData tickerData) alternarSelecao;

  const TickerSquareCard({
    super.key,
    required this.tickerData,
    required this.favoritadas,
    required this.mostrarDetalhes,
    required this.alternarSelecao,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColor = tickerData.change > 0
        ? Colors.green
        : tickerData.change < 0
            ? Colors.red
            : Colors.blueGrey;

    final bool isSelecionado = favoritadas.contains(tickerData);

    return InkWell(
      onTap: () => mostrarDetalhes(tickerData),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: const Alignment(0, -1),
            colors: [
              gradientColor.withAlpha(65),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gradientColor.withAlpha(75),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: Icon(
                  isSelecionado ? Icons.star : Icons.star_border,
                  color: isSelecionado ? Colors.amber : Colors.grey,
                  size: 25,
                ),
                onPressed: () => alternarSelecao(tickerData),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tickerData.stock,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                Text(
                  tickerData.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 2.5),
                            FlSpot(1, 3.0),
                            FlSpot(2, 3.2),
                            FlSpot(3, 2.8),
                            FlSpot(4, 3.5),
                          ],
                          isCurved: true,
                          color: gradientColor.withAlpha(100),
                          barWidth: 2,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                      minY: 2,
                      maxY: 4,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${tickerData.close.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '${tickerData.change > 0 ? '+' : ''}${tickerData.change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: gradientColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
