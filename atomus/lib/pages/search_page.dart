import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/ticker/ticker_data.dart';
import '../services/search_service.dart';
import '../widgets/ticker_square_card.dart';
import '../widgets/ticker_list_card.dart';
import 'ticker_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<TickerData>>? _tickerListFuture;
  final List<TickerData> _favoritadas = [];
  bool _showSelecionadas = false;
  bool _isIconOne = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTickerData();
  }

  Future<void> _loadTickerData() async {
    final searchService = Provider.of<SearchService>(context, listen: false);
    final cachedBox = await Hive.openBox<TickerData>('tickersBox');

    final cachedData = cachedBox.values.toList();
    if (cachedData.isNotEmpty) {
      setState(() {
        _tickerListFuture = Future.value(cachedData);
      });
    } else {
      final tickerList = await searchService.getTickerList();
      setState(() {
        _tickerListFuture = Future.value(tickerList);
      });
      _cacheTickerData(tickerList);
    }
  }

  Future<void> _cacheTickerData(List<TickerData> tickerList) async {
    final box = await Hive.openBox<TickerData>('tickersBox');
    for (var ticker in tickerList) {
      await box.put(ticker.stock, ticker);
    }
  }

  Future<void> _reloadData() async {
    final searchService = Provider.of<SearchService>(context, listen: false);
    final tickerList = await searchService.getTickerList();

    setState(() {
      _tickerListFuture = Future.value(tickerList);
    });

    _cacheTickerData(tickerList);
  }

  void _mostrarDetalhes(TickerData tickerData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TickerDetailsPage(ticker: tickerData.stock),
      ),
    );
  }

  void _alternarSelecao(TickerData tickerData) {
    setState(() {
      if (_favoritadas.contains(tickerData)) {
        _favoritadas.remove(tickerData);
      } else {
        _favoritadas.add(tickerData);
      }
    });
  }

  List<TickerData> _filterTickers(List<TickerData> tickers) {
    if (_searchQuery.isEmpty) {
      return tickers;
    }

    return tickers.where((ticker) {
      return ticker.stock.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticker.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 35),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isIconOne = !_isIconOne;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isIconOne
                            ? [Colors.blueGrey, Colors.grey]
                            : [Colors.yellow, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isIconOne ? Icons.dashboard_rounded : Icons.list_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showSelecionadas = !_showSelecionadas;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: _showSelecionadas
                          ? Border.all(width: 0.5, color: Colors.white70)
                          : Border(),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _showSelecionadas ? Icons.star : Icons.star_border,
                          color:
                              _showSelecionadas ? Colors.amber : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Favoritas',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _showSelecionadas
                  ? _buildSelecionadasGrid()
                  : _buildTickerListOrGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelecionadasGrid() {
    if (_favoritadas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum ativo selecionado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return _isIconOne
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _favoritadas.length,
            itemBuilder: (context, index) {
              final ativo = _favoritadas[index];
              return TickerSquareCard(
                tickerData: ativo,
                favoritadas: _favoritadas,
                mostrarDetalhes: _mostrarDetalhes,
                alternarSelecao: _alternarSelecao,
              );
            },
          )
        : ListView.builder(
            itemCount: _favoritadas.length,
            itemBuilder: (context, index) {
              final ativo = _favoritadas[index];
              return ListTile(
                leading:
                    const Icon(Icons.check_circle, color: Colors.amberAccent),
                title: Text(ativo.stock),
                subtitle: const Text('Detalhes do ativo'),
                onTap: () => _mostrarDetalhes(ativo),
              );
            },
          );
  }

  Widget _buildTickerListOrGrid() {
    return FutureBuilder<List<TickerData>>(
      future: _tickerListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum ativo encontrado.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final ativos = snapshot.data!;
        final filteredTickers = _filterTickers(ativos);

        return RefreshIndicator(
          onRefresh: _reloadData,
          child: _isIconOne
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredTickers.length,
                  itemBuilder: (context, index) {
                    final ativo = filteredTickers[index];
                    return TickerSquareCard(
                      tickerData: ativo,
                      favoritadas: _favoritadas,
                      mostrarDetalhes: _mostrarDetalhes,
                      alternarSelecao: _alternarSelecao,
                    );
                  },
                )
              : ListView.builder(
                  itemCount: filteredTickers.length,
                  itemBuilder: (context, index) {
                    final ativo = filteredTickers[index];
                    return TickerListCard(
                      tickerData: ativo,
                      favoritadas: _favoritadas,
                      mostrarDetalhes: _mostrarDetalhes,
                      alternarSelecao: _alternarSelecao,
                    );
                  },
                ),
        );
      },
    );
  }
}
