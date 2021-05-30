import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'classes/trigger_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserModel model = UserModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: model,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, widget, model) {
          return MaterialApp(
            title: 'Flutter\'s Clothing',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color.fromARGB(255, 4, 125, 141),
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
