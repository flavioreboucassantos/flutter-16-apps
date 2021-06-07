import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/order_screen.dart';

class CartPrice extends TriggerBuilder<CartModel> {
  CartPrice()
      : super(
          model: CartModel.model,
          keyBuilder: 'prices',
        );

  @override
  Widget build(
    BuildContext context,
    CartModel model,
    Map<String, dynamic> data,
  ) {
    Color primaryColor = Theme.of(context).primaryColor;

    model.updateProductsPrice();
    double price = model.getProductsPrice();
    double discount = model.getDiscount();
    double ship = model.getShipPrice();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal'),
                Text('R\$ ${price.toStringAsFixed(2)}'),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Desconto'),
                Text('R\$ ${discount.toStringAsFixed(2)}'),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Entrega'),
                Text('R\$ ${ship.toStringAsFixed(2)}'),
              ],
            ),
            Divider(),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'R\$ ${(price + ship - discount).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                String orderId = await model.finishOrder();
                if (orderId != null)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(orderId),
                    ),
                  );
              },
              child: Text('Finalizar Pedido'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
