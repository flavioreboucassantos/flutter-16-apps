import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/classes/trigger_map.dart';
import 'package:flutter/material.dart';

import 'cart_model.dart';

class UserModel extends TriggerMap {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;

  Map<String, dynamic> userData = Map();
  CartModel cartModel;

  bool isLoading = false;

  UserModel() {
    _loadCurrentUser();
    cartModel = TriggerMap.singleton<CartModel>(CartModel(this));
  }

  void signUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) {
    isLoading = true;
    triggerEvent();

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      triggerEvent();

      cartModel.reset();
    }).catchError((e) {
      onFail();
      isLoading = false;
      triggerEvent();
    });
  }

  void signIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    triggerEvent();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      triggerEvent();

      cartModel.reset();
    }).catchError((e) {
      onFail();
      isLoading = false;
      triggerEvent();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    triggerEvent();

    cartModel.reset();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<void> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        userData = docUser.data();
      }
    }
    triggerEvent();
  }
}
