import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot<Map<String, dynamic>>> data =
                  snapshot.data ?? <DocumentSnapshot<Map<String, dynamic>>>[];
              if (data.length == 0)
                return Center(
                  child: Text(
                    'Nenhum pedido encontrado!',
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                );
              else
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => OrderTile(data[index]),
                );
            } else
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.pinkAccent,
                ),
              );
          }),
    );
  }
}
