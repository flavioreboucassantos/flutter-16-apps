import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final BehaviorSubject<List<Map<String, dynamic>>> _usersController =
      BehaviorSubject<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get outUsers => _usersController.stream;

  final Map<String, Map<String, dynamic>> _users =
      Map<String, Map<String, dynamic>>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((docChange) {
        String uid = docChange.doc.id;
        Map<String, dynamic> data =
            docChange.doc.data() ?? Map<String, dynamic>();
        switch (docChange.type) {
          case DocumentChangeType.added:
            _users[uid] = data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid]!.addAll(data);
            _usersController.add(_users.values.toList(growable: false));
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList(growable: false));
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]!['subscription'] = _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.docs.length;

      double money = 0.0;

      for (DocumentSnapshot d in orders.docs) {
        DocumentSnapshot<Map<String, dynamic>> order =
            await _firestore.collection('orders').doc(d.id).get();
        money += order.data()!['totalPrice'];
      }

      _users[uid]!.addAll({
        'money': money,
        'orders': numOrders,
      });

      _usersController.add(_users.values.toList(growable: false));
    });
  }

  void _unsubscribeToOrders(String uid) {
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subscription =
        _users[uid]!['subscription'];
    subscription.cancel();
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList(growable: false));

    filteredUsers.retainWhere(
      (user) =>
          (user['name'] as String).toUpperCase().contains(search.toUpperCase()),
    );

    return filteredUsers;
  }

  @override
  void dispose() {
    _usersController.close();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty)
      _usersController.add(_users.values.toList(growable: false));
    else
      _usersController.add(_filter(search.trim()));
  }
}
