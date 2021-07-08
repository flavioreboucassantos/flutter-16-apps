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

  InputDecoration _buildDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final TextStyle _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
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
        child: StreamBuilder<Map<String, dynamic>>(
            stream: _productBloc.outData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              Map<String, dynamic> data = snapshot.data ?? <String, dynamic>{};
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: data['title'],
                    style: _fieldStyle,
                    decoration: _buildDecoration('Titulo'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: data['description'],
                    style: _fieldStyle,
                    maxLines: 6,
                    decoration: _buildDecoration('Descrição'),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                  TextFormField(
                    initialValue: data['price'] == null
                        ? ''
                        : (data['price'] as double).toStringAsFixed(2),
                    style: _fieldStyle,
                    decoration: _buildDecoration('Preço'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t) {},
                    validator: (t) {},
                  ),
                ],
              );
            }),
      ),
    );
  }
}
