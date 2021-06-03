import 'package:loja_virtual/classes/trigger_builder.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserModel model = TriggerModel.singleton<UserModel>(UserModel());

  @override
  Widget build(BuildContext context) => TriggerBuilder<UserModel>(
        model: model,
        builder: (context, model, data) => MaterialApp(
          title: 'Flutter\'s Clothing',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 4, 125, 141),
          ),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      );
}
