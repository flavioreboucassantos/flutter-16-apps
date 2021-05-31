import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/cart_product_tile.dart';
import 'package:loja_virtual/widgets/cart_prices.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';

class CartScaffoldBody extends StatefulWidget {
  @override
  _CartScaffoldBodyState createState() => _CartScaffoldBodyState();
}

class _CartScaffoldBodyState extends State<CartScaffoldBody> {
  final CartModel model = TriggerMap.singleton<CartModel>();

  @override
  void dispose() {
    super.dispose();
    model.unsubscribe(key: 'body');
  }

  @override
  Widget build(BuildContext context) {
    model.subscribe((data) {
      setState(() {});
    }, 'body');

    bool isLoggedIn = UserModel.of(context).isLoggedIn();
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
                (cartProduct) => CartProductTile(cartProduct),
              )
              .toList(),
        ),
        DiscountCard(),
        ShipCard(),
        CartPrices(() async {
          String orderId = await model.finishOrder();
          if (orderId != null) print(orderId);
        }),
      ],
    );
  }
}
