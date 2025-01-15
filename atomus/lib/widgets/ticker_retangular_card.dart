import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/ticker/ticker_data.dart';

class TickerRetangularCard extends StatelessWidget {
  final TickerData ativo;
  final Function mostrarDetalhes;
  final Function alternarSelecao;

  const TickerRetangularCard({
    super.key,
    required this.ativo,
    required this.mostrarDetalhes,
    required this.alternarSelecao,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColor = ativo.change > 0
        ? Colors.green
        : ativo.change < 0
            ? Colors.red
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            gradientColor.withAlpha(80),
            Colors.transparent,
          ],
          stops: [0.2, 1],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: gradientColor.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: SvgPicture.network(
          ativo.logo,
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
          ativo.stock,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          ativo.name,
          style: const TextStyle(
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${ativo.close.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              '${ativo.change > 0 ? '+' : ''}${ativo.change.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 15,
                color: gradientColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => mostrarDetalhes(ativo),
        onLongPress: () => alternarSelecao(ativo),
      ),
    );
  }
}
