import '../models/ticker/ticker_data.dart';
import 'package:flutter/material.dart';

class TickerSquareCard extends StatelessWidget {
  final TickerData tickerData;
  final List<TickerData> selecionadas;
  final void Function(TickerData tickerData) mostrarDetalhes;
  final void Function(TickerData tickerData) alternarSelecao;

  const TickerSquareCard({
    super.key,
    required this.tickerData,
    required this.selecionadas,
    required this.mostrarDetalhes,
    required this.alternarSelecao,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColor = tickerData.change > 0
        ? Colors.green
        : tickerData.change < 0
            ? Colors.red
            : Colors.grey;

    final bool isSelecionado = selecionadas.contains(tickerData);

    return InkWell(
      onTap: () => mostrarDetalhes(tickerData),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: const Alignment(0, -1),
            colors: [
              gradientColor.withAlpha(80),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gradientColor.withAlpha(80),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        child: Stack(
          children: [
            Positioned(
              top: -12,
              right: -10,
              child: IconButton(
                icon: Icon(
                  isSelecionado ? Icons.star : Icons.star_border,
                  color: isSelecionado ? Colors.amber : Colors.grey,
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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tickerData.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 55),
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
