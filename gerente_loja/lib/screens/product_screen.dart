import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/validators/product_validator.dart';
import 'package:gerente_loja/widgets/images_widget.dart';

class ProductScreen extends StatelessWidget with ProductValidator {
  final String categoryId;
  final DocumentSnapshot<Map<String, dynamic>>? product;

  final ProductBloc _productBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final BuildContext _context;

  ProductScreen({required this.categoryId, this.product})
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  InputDecoration _buildDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      );

  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(
            'Salvando produto...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      bool success = await _productBloc.saveProduct();
      ScaffoldMessenger.of(_context).removeCurrentSnackBar();

      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Produto salvo!' : 'Erro ao salvar produto!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final TextStyle _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              bool data = snapshot.data ?? false;
              return Text(data ? 'Editar Produto' : 'Criar Produto');
            }),
        actions: [
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              bool data = snapshot.data ?? false;
              if (data)
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      bool data = snapshot.data ?? false;
                      return IconButton(
                        onPressed: data ? null : () {
                          _productBloc.deleteProduct();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.remove),
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                bool data = snapshot.data ?? false;
                return IconButton(
                  onPressed: data ? null : saveProduct,
                  icon: Icon(Icons.save),
                );
              }),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map<String, dynamic>>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  Map<String, dynamic> data =
                      snapshot.data ?? <String, dynamic>{};
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(
                        'Imagens',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: data['images'],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: data['title'],
                        style: _fieldStyle,
                        decoration: _buildDecoration('Titulo'),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: data['description'],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration('Descrição'),
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue: data['price'] == null
                            ? ''
                            : (data['price'] as double).toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration('Preço'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                bool data = snapshot.data ?? false;
                return IgnorePointer(
                  ignoring: !data,
                  child: Container(
                    color: data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
