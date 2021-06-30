import 'package:flutter/material.dart';
import 'package:gerente_loja/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        backgroundColor: Colors.pinkAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: (pageIndex) {
          _pageController.animateToPage(
            pageIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produtos',
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
          children: [
            UsersTab(),
            Container(color: Colors.yellow),
            Container(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
