import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final UserBloc _userBloc = UserBloc();
  final OrdersBloc _ordersBloc = OrdersBloc();

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
        child: BlocProvider(
          blocs: [
            Bloc((i) => _userBloc),
            Bloc((i) => _ordersBloc),
          ],
          dependencies: [],
          child: PageView(
            controller: _pageController,
            onPageChanged: (pageIndex) {
              setState(() {
                _pageIndex = pageIndex;
              });
            },
            children: [
              UsersTab(),
              OrdersTab(),
              Container(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
