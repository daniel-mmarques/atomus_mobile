import 'package:flutter/material.dart';
import 'portfolio_page.dart';
import 'settings_page.dart';
import 'historico_page.dart';
import 'search_page.dart';
import 'package:flutter/services.dart';

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

  @override
  void dispose() {
    pc.dispose();
    super.dispose();
  }

  void _onIconTap(int index) {
    HapticFeedback.lightImpact();
    pc.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() => paginaAtual = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PageView(
              controller: pc,
              onPageChanged: (index) => setState(() => paginaAtual = index),
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                SearchPage(),
                PortfolioPage(),
                HistoricoPage(),
                SettingsPage(),
              ],
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 6,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F26),
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavigationButton(
                    index: 0,
                    icon: Icons.search_outlined,
                    iconSelected: Icons.search_rounded,
                    title: "Search",
                  ),
                  _buildNavigationButton(
                    index: 1,
                    icon: Icons.dashboard_outlined,
                    iconSelected: Icons.dashboard_rounded,
                    title: "Wallet",
                  ),
                  _buildNavigationButton(
                    index: 2,
                    icon: Icons.history_outlined,
                    iconSelected: Icons.history_rounded,
                    title: "History",
                  ),
                  _buildNavigationButton(
                    index: 3,
                    icon: Icons.manage_accounts_outlined,
                    iconSelected: Icons.manage_accounts_rounded,
                    title: "Account",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required int index,
    required IconData icon,
    required IconData iconSelected,
    required String title,
  }) {
    final bool isActive = paginaAtual == index;

    return GestureDetector(
      onTap: () => _onIconTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3861FB) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? iconSelected : icon,
              color: isActive ? Colors.white : const Color(0xFFBBBBBB),
              size: isActive ? 28 : 26,
            ),
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
