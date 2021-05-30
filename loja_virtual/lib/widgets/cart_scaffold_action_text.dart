import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartScaffoldActionText extends StatefulWidget {
  @override
  _CartScaffoldActionTextState createState() => _CartScaffoldActionTextState();
}

class _CartScaffoldActionTextState extends State<CartScaffoldActionText> {
  final CartModel model = TriggerMap.singleton<CartModel>();

  void update(Map<String, dynamic> data) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    model.subscribe(update, keys: ['length']);
  }

  @override
  void dispose() {
    super.dispose();
    model.unsubscribe(update);
  }

  @override
  Widget build(BuildContext context) {
    int p = model.products.length;
    return Text(
      '${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}',
      style: TextStyle(
        fontSize: 17.0,
      ),
    );
  }
}
