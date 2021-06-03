import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountCard extends StatelessWidget {
  final CartModel model = TriggerModel.singleton<CartModel>();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        collapsedTextColor: Colors.grey[700],
        iconColor: primaryColor,
        textColor: primaryColor,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom',
              ),
              initialValue: model.couponCode ?? '',
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection('coupons')
                    .doc(text)
                    .get()
                    .then((documentSnapshot) {
                  if (documentSnapshot.data() != null) {
                    int discountPercentage = documentSnapshot.data()['percent'];
                    model.setCoupon(text, discountPercentage);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Desconto de $discountPercentage% aplicado!',
                        ),
                        backgroundColor: primaryColor,
                      ),
                    );
                  } else {
                    model.setCoupon(null, 0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cupom não existente!',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
