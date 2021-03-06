import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends TriggerModel {
  static CartModel model;

  UserModel user;

  List<CartProduct> products = [];
  int productsToLoad = 0;

  String couponCode;
  int discountPercentage = 0;

  double _productsPrice = 0.0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  void _loadCartItems() async {
    isLoading = true;

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    isLoading = false;
    notifyListeners(['length', 'body']);
  }

  void reset() {
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    if (user.isLoggedIn()) _loadCartItems();
  }

  void addCartItem(CartProduct cartProduct) {
    isLoading = true;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
      products.add(cartProduct);

      isLoading = false;
      notifyListeners(['length', 'body']);
    });
  }

  void removeCartItem(CartProduct cartProduct) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners(['length', 'body']);
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update({'quantity': cartProduct.quantity});

    notifyListeners([cartProduct.cid, 'prices']);
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update({'quantity': cartProduct.quantity});

    notifyListeners([cartProduct.cid, 'prices']);
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;

    notifyListeners(['prices']);
  }

  void updatePrices() {
    notifyListeners(['prices']);
  }

  void updateProductsPrice() {
    _productsPrice = 0.0;
    for (CartProduct c in products)
      if (c.productData != null)
        _productsPrice += c.quantity * c.productData.price;
  }

  double getProductsPrice() {
    return _productsPrice;
  }

  double getDiscount() {
    return _productsPrice * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners(['body']);

    updateProductsPrice();
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser.uid,
      'products': products
          .map((cartProduct) => cartProduct.toMap())
          .toList(growable: false),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('cart')
        .get();

    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners(['length', 'body']);

    return refOrder.id;
  }
}
