import 'package:flutter/material.dart';
import 'package:fluttertube/screens/home.dart';

import 'api.dart';

void main() {

  Api api = Api();
  
  api.search('minecraft');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTube',
      home: Home(),
    );
  }
}
