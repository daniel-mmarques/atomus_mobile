import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/ticker/ticker_data.dart';

class TickerListCard extends StatelessWidget {
  final TickerData tickerData;
  final void Function(TickerData tickerData) mostrarDetalhes;
  final void Function(TickerData tickerData) alternarSelecao;
  final List<TickerData> favoritadas;

  const TickerListCard({
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
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            gradientColor.withAlpha(50),
            Colors.transparent,
          ],
          stops: [0.2, 1],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: gradientColor.withAlpha(60),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: SvgPicture.network(
          tickerData.logo,
          height: 45,
          width: 45,
          placeholderBuilder: (context) => const SizedBox(
            height: 45,
            width: 45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        title: Text(
          tickerData.stock,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          tickerData.name,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${tickerData.close.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '${tickerData.change > 0 ? '+' : ''}${tickerData.change.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                color: gradientColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => mostrarDetalhes(tickerData),
        onLongPress: () => alternarSelecao(tickerData),
      ),
    );
  }
}
