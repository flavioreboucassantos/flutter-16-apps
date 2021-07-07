import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductBloc extends BlocBase {
  final String categoryId;
  final DocumentSnapshot<Map<String, dynamic>>? product;

  ProductBloc({required this.categoryId, this.product}) {

  }
}
