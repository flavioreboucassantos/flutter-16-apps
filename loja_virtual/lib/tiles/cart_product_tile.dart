import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartProductTile extends StatefulWidget {
  final CartProduct cartProduct;

  CartProductTile(this.cartProduct);

  @override
  _CartProductTileState createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  CartModel model = TriggerMap.singleton<CartModel>();
  CartProduct cartProduct;

  Widget _buildContent() {
    Color primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: 120.0,
          child: Image.network(cartProduct.productData.images[0]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cartProduct.productData.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                ),
                Text(
                  'Tamanho: ${cartProduct.size}',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  'R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: primaryColor,
                      onPressed: cartProduct.quantity > 1
                          ? () {
                              model.decProduct(cartProduct);
                            }
                          : null,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: primaryColor,
                      onPressed: () {
                        model.incProduct(cartProduct);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        model.removeCartItem(cartProduct);
                      },
                      child: Text(
                        'Remover',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getChild() {
    if (cartProduct.productData == null) {
      model.productsToLoad++;
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(cartProduct.category)
            .collection('items')
            .doc(cartProduct.pid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            cartProduct.productData = ProductData.fromDocument(snapshot.data);

            model.productsToLoad--;
            if (model.productsToLoad == 0) model.updatePrices();

            return _buildContent();
          } else
            return Container(
              height: 70.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
        },
      );
    }
    return _buildContent();
  }

  @override
  Widget build(BuildContext context) {
    cartProduct = widget.cartProduct;
    model.subscribe((data) {
      setState(() {});
    }, cartProduct.cid);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: _getChild(),
    );
  }
}
