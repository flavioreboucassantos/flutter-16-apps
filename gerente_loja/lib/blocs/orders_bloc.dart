import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BlocBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final BehaviorSubject<List<DocumentSnapshot<Map<String, dynamic>>>>
      _ordersController =
      BehaviorSubject<List<DocumentSnapshot<Map<String, dynamic>>>>();

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> get outOrders =>
      _ordersController.stream;

  List<DocumentSnapshot<Map<String, dynamic>>> _orders =
      <DocumentSnapshot<Map<String, dynamic>>>[];

  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == uid);
            _orders.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == uid);
            break;
        }
      });

      _ordersController.add(_orders);
    });
  }
}
