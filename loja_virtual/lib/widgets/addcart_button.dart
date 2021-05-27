import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class AddCartButton extends StatefulWidget {
  final ProductData productData;

  AddCartButton(this.productData);

  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  TriggerMap _addCartTriggerMap = TriggerMap.instance('addCart');
  bool _loaded = false;

  _AddCartButtonState() {
    _addCartTriggerMap.addListener((Map<String, dynamic> data) {
      if (!_loaded) {
        _loaded = true;
        setState(() {});
      }
    });
  }

  Color _getBackgroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.grey;
    }
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: ElevatedButton(
        onPressed: _loaded
            ? () {
                if (UserModel.of(context).isLoggedIn()) {
                  CartProduct cartProduct = CartProduct();
                  cartProduct.size = _addCartTriggerMap.map['size'];
                  cartProduct.quantity = 1;
                  cartProduct.pid = widget.productData.id;
                  cartProduct.category = widget.productData.category;

                  CartModel.of(context).addCartItem(cartProduct);

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
          UserModel.of(context).isLoggedIn()
              ? 'Adicionar ao Carrinho'
              : 'Entre para Comprar',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith(_getBackgroundColor),
        ),
      ),
    );
  }
}
