import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/screens/home.dart';

import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'FlutterTube',
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
      blocs: [
        Bloc((i) => VideosBloc()),
      ],
      dependencies: [],
    );
  }
}
