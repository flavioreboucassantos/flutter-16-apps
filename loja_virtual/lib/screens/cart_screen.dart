import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/cart_product_tile.dart';
import 'package:loja_virtual/widgets/cart_prices.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';

import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  final CartModel cartModel = TriggerMap.singleton<CartModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: TriggerBuilder<CartModel>(
              model: cartModel,
              keyBuilder: 'length',
              builder: (context, model, data) {
                int p = model.products.length;
                return Text(
                  '${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: TriggerBuilder<CartModel>(
        model: cartModel,
        keyBuilder: 'body',
        builder: (context, model, data) {
          bool isLoggedIn = TriggerMap.singleton<UserModel>().isLoggedIn();
          Color primaryColor = Theme.of(context).primaryColor;

          if (model.isLoading && isLoggedIn)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (!isLoggedIn)
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Faça o login para adicionar produtos!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          else if (model.products == null || model.products.length == 0)
            return Center(
              child: Text(
                'Nenhum produto no carrinho!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );

          model.productsToLoad = 0;
          return ListView(
            children: [
              Column(
                children: model.products
                    .map(
                      (cartProduct) => TriggerBuilder<CartModel>(
                        model: cartModel,
                        keyBuilder: cartProduct.cid,
                        builder: (context, model, data) => cartProductTile(
                          context,
                          model,
                          cartProduct,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
              DiscountCard(),
              ShipCard(),
              TriggerBuilder<CartModel>(
                model: cartModel,
                keyBuilder: 'prices',
                builder: (context, model, data) => cartPrices(
                  context,
                  model,
                  data,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
