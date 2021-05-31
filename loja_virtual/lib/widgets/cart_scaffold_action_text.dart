import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartScaffoldActionText extends StatefulWidget {
  @override
  _CartScaffoldActionTextState createState() => _CartScaffoldActionTextState();
}

class _CartScaffoldActionTextState extends State<CartScaffoldActionText> {
  final CartModel model = TriggerMap.singleton<CartModel>();

  @override
  void dispose() {
    super.dispose();
    model.unsubscribe(key: 'length');
  }

  @override
  Widget build(BuildContext context) {
    model.subscribe((data) {
      setState(() {});
    }, 'length');

    int p = model.products.length;
    return Text(
      '${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}',
      style: TextStyle(
        fontSize: 17.0,
      ),
    );
  }
}
