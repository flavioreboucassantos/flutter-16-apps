import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';

class ProductScreen extends StatelessWidget {
  final String categoryId;
  final DocumentSnapshot<Map<String, dynamic>>? product;

  final ProductBloc _productBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductScreen({required this.categoryId, this.product})
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text('Criar Produto'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [],
        ),
      ),
    );
  }
}
