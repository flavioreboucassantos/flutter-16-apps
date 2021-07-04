import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';

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

    final UserBloc userBloc = BlocProvider.getBloc<UserBloc>();
    final Map<String, dynamic> userData =
        userBloc.getUser(data['clientId']) ?? Map<String, dynamic>();

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
              key: Key(order.id),
              initiallyExpanded: data['status'] != 4,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData['name']),
                              Text(userData['address']),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Produtos: R\$ ${(data['productsPrice'] as double).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                  'Total: R\$ ${(data['totalPrice'] as double).toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      ),
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
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(order['clientId'])
                                  .collection('orders')
                                  .doc(order.id)
                                  .delete();
                              order.reference.delete();
                            },
                            child: Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: data['status'] > 1
                                ? () {
                                    order.reference
                                        .update({'status': data['status'] - 1});
                                  }
                                : null,
                            child: Text(
                              'Regredir',
                              style: TextStyle(
                                color: Colors.grey[850],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: data['status'] < 4
                                ? () {
                                    order.reference
                                        .update({'status': data['status'] + 1});
                                  }
                                : null,
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
