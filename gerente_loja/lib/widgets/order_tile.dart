import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> order;

  OrderTile(this.order);

  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando entrega',
    'Entregue',
  ];

  @override
  Widget build(BuildContext context) {
    final String id = order.id.substring(0, 10);
    final Map<String, dynamic> data = order.data() ?? Map<String, dynamic>();
    if (data.isEmpty)
      return Container(
        padding: const EdgeInsets.all(24.0),
        child: Text('Data is Empty'),
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                '#$id - ${states[data['status']]}',
                style: TextStyle(
                  color: data['status'] == 4 ? Colors.green : Colors.grey[850],
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderHeader(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: (data['products'] as List).map((product) {
                          Map<String, dynamic> p = product;
                          return ListTile(
                            title:
                                Text(p['product']['title'] + ' ' + p['size']),
                            subtitle: Text(p['category'] + '/' + p['pid']),
                            trailing: Text(
                              p['quantity'].toString(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(growable: false),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Regredir',
                              style: TextStyle(
                                color: Colors.grey[850],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Avançar',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
