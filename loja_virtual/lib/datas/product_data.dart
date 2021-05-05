import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;
  double price;
  List<String> images;
  List<String> sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.data()['title'];
    description = snapshot.data()['description'];
    price = snapshot.data()['price'];
    images = snapshot.data()['images'];
    sizes = snapshot.data()['sizes'];
  }
}
