import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    for (LinkedHashMap<String, dynamic> p in snapshot.data()['products']) {
      text += '${p['quantity']} x ${p['product']['title']} ';
      text += '(R\$ ${(p['product']['price'] as double).toStringAsFixed(2)})\n';
    }
    text +=
        'Total: R\$ ${(snapshot.data()['totalPrice'] as double).toStringAsFixed(2)}';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    context = safeContext;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código do pedido: $orderId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(_buildProductsText(snapshot.data))
                ],
              );
          },
        ),
      ),
    );
  }
}
