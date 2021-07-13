import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final BehaviorSubject<Map<String, dynamic>> _dataController =
  BehaviorSubject<Map<String, dynamic>>();

  final BehaviorSubject<bool> _loadingController = BehaviorSubject<bool>();

  final BehaviorSubject<bool> _createdController = BehaviorSubject<bool>();

  Stream<Map<String, dynamic>> get outData => _dataController.stream;

  Stream<bool> get outLoading => _loadingController.stream;

  Stream<bool> get outCreated => _createdController.stream;

  final String categoryId;
  final DocumentSnapshot<Map<String, dynamic>>? product;

  late final Map<String, dynamic> unsavedData;

  ProductBloc({required this.categoryId, this.product}) {
    if (product == null) {
      unsavedData = <String, dynamic>{
        'images': <String>[],
        'sizes': <String>[],
      };

      _createdController.add(false);
    } else {
      unsavedData = Map.of(product!.data() ?? <String, dynamic>{});
      unsavedData['images'] = List.of(product!.data()!['images']);
      unsavedData['sizes'] = List.of(product!.data()!['sizes']);

      _createdController.add(true);
    }

    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    super.dispose();
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

  Future _uploadImages(String productId,) async {
    List<dynamic> images = unsavedData['images'] ?? [];
    for (int i = 0; i < images.length; i++) {
      if (images[i] is String) continue;

      final UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString())
          .putFile(images[i]);

      await uploadTask.whenComplete(() async {
        String downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
        images[i] = downloadUrl;
      });
    }
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product == null) {
        DocumentReference<Map<String, dynamic>> doc = await FirebaseFirestore
            .instance
            .collection('products')
            .doc(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)
          ..remove('images'));
        await _uploadImages(doc.id);
        await doc.update(unsavedData);
      } else {
        await _uploadImages(product!.id);
        await product!.reference.update(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  void deleteProduct() {
    product!.reference.delete();
  }
}
