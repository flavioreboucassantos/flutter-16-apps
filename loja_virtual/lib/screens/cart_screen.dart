import 'package:flutter/material.dart';
import 'package:loja_virtual/widgets/cart_scaffold_action_text.dart';
import 'package:loja_virtual/widgets/cart_scaffold_body.dart';

class CartScreen extends StatelessWidget {
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
            child: CartScaffoldActionText(),
          )
        ],
      ),
      body: CartScaffoldBody(),
    );
  }
}
