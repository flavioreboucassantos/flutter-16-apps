import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot document) {
    id = document.id;
    title = document.data()['title'];
    description = document.data()['description'];
    price = document.data()['price'];
    images = document.data()['images'];
    sizes = document.data()['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
