import 'portfolio_page.dart';
import 'configuracoes_page.dart';
import 'historico_page.dart';
import 'search_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 1;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: [
          SearchPage(),
          PortfolioPage(),
          HistoricoPage(),
          ConfiguracoesPage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              alignment: _getAlignmentForIndex(paginaAtual),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFF00),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavigationButton(
                    index: 0,
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search),
                _buildNavigationButton(
                    index: 1,
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded),
                _buildNavigationButton(
                    index: 2,
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history_rounded),
                _buildNavigationButton(
                    index: 3,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required int index,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isActive = paginaAtual == index;

    return GestureDetector(
      onTap: () => _onIconTap(index),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? Colors.black : const Color(0xFFBBBBBB),
          size: isActive ? 25 : 20, // Ícone maior quando ativo
        ),
      ),
    );
  }

  void _onIconTap(int index) {
    pc.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setPaginaAtual(index);
  }

  Alignment _getAlignmentForIndex(int index) {
    // Corrigindo os alinhamentos para 4 botões
    switch (index) {
      case 0:
        return Alignment(-1, 0);
      case 1:
        return Alignment(-0.335, 0);
      case 2:
        return Alignment(0.335, 0);
      case 3:
        return Alignment(1, 0);
      default:
        return Alignment.center;
    }
  }
}
