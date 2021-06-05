import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatelessWidget {
  final TriggerMap cartProductModel = TriggerMap.instance('CartProductModel');

  final ProductData productData;

  ProductScreen(this.productData);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    cartProductModel.map.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images:
                  productData.images.map((url) => NetworkImage(url)).toList(growable: false),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  productData.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${productData.price.toString()}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TriggerBuilder<TriggerMap>(
                  model: cartProductModel,
                  builder: (context, model, data) {
                    final Color primaryColor = Theme.of(context).primaryColor;

                    return SizedBox(
                      height: 34.0,
                      child: GridView(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5,
                        ),
                        children: productData.sizes
                            .map(
                              (size) => GestureDetector(
                                onTap: () {
                                  model.setKey('size', size);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                    border: Border.all(
                                      color: model.map['size'] == size
                                          ? primaryColor
                                          : Colors.grey[500],
                                      width: 3.0,
                                    ),
                                  ),
                                  width: 50.0,
                                  alignment: Alignment.center,
                                  child: Text(size),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TriggerBuilder<TriggerMap>(
                  model: cartProductModel,
                  rebuildOnChange: () => cartProductModel.map['setted'] == null,
                  builder: (context, model, data) {
                    if (model.map['size'] != null) model.map['setted'] = true;

                    return SizedBox(
                      height: 44.0,
                      child: ElevatedButton(
                        onPressed: model.map['setted'] != null
                            ? () {
                                if (CartModel.model.user.isLoggedIn()) {
                                  CartProduct cartProduct = CartProduct();
                                  cartProduct.size = model.map['size'];
                                  cartProduct.quantity = 1;
                                  cartProduct.pid = productData.id;
                                  cartProduct.category = productData.category;

                                  CartModel.model.addCartItem(cartProduct);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          CartModel.model.user.isLoggedIn()
                              ? 'Adicionar ao Carrinho'
                              : 'Entre para Comprar',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              }
                              return Theme.of(context).primaryColor;
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  productData.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
