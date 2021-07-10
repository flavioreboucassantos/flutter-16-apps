import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final BehaviorSubject<Map<String, dynamic>> _dataController =
      BehaviorSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get outData => _dataController.stream;

  final String categoryId;
  final DocumentSnapshot<Map<String, dynamic>>? product;

  late final Map<String, dynamic> unsavedData;

  ProductBloc({required this.categoryId, this.product}) {
    if (product == null)
      unsavedData = <String, dynamic>{
        'images': <String>[],
        'sizes': <String>[],
      };
    else {
      unsavedData = Map.of(product!.data() ?? <String, dynamic>{});
      unsavedData['images'] = List.of(product!.data()!['images']);
      unsavedData['sizes'] = List.of(product!.data()!['sizes']);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String? title) {
    unsavedData['title'] = title;
  }

  void saveDescription(String? description) {
    unsavedData['description'] = description;
  }

  void savePrice(String? price) {
    unsavedData['price'] = double.parse(price!);
  }

  void saveImages(List<dynamic>? images) {
    unsavedData['images'] = images;
  }

  @override
  void dispose() {
    _dataController.close();
    super.dispose();
  }
}
