import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {
  IDLE,
  LOADING,
  SUCCESS,
  FAIL,
}

class LoginBloc extends BlocBase with LoginValidators {
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<LoginState> _stateController =
      BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  late final StreamSubscription<User?> _streamSubscription;

  LoginBloc() {
    _streamSubscription =
        FirebaseAuth.instance.userChanges().listen((user) async {
      if (user == null)
        _stateController.add(LoginState.IDLE);
      else if (await verifyPrivileges(user))
        _stateController.add(LoginState.SUCCESS);
      else {
        FirebaseAuth.instance.signOut();
        _stateController.add(LoginState.FAIL);
      }
    });
  }

  void submit() async {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get()
        .then((doc) {
      return doc.data() == null ? false : true;
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
    super.dispose();
  }
}
