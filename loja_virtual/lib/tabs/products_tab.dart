import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children: ListTile.divideTiles(
              tiles: snapshot.data.docs.map((doc) => CategoryTile(doc)),
              color: Colors.grey[500],
            ).toList(growable: false),
          );
      },
    );
  }
}
