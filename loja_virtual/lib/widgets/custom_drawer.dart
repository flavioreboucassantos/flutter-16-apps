import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel model = TriggerModel.singleton<UserModel>();

  final PageController _pageController;

  CustomDrawer(this._pageController);

  Widget _buildDrawerBack() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 236, 241),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top: 16.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        'Flutter\'s\nClothing',
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${model.isLoggedIn() ? model.userData['name'] : ''}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              model.isLoggedIn()
                                  ? 'Sair'
                                  : 'Entre ou cadastre-se >',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              if (model.isLoggedIn())
                                model.signOut();
                              else
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', _pageController, 0),
              DrawerTile(Icons.list, 'Produtos', _pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', _pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, 'Meus Pedidos', _pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
