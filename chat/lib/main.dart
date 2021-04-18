import 'package:chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  /*
  FirebaseFirestore.instance.collection('mensagens').doc().set({
    'texto': 'Boa noite',
    'from': 'Pessoa',
  });
  FirebaseFirestore.instance
      .collection('mensagens')
      .doc('kV4qdMAgzP2B8SA4cKmz')
      .snapshots()
      .listen((dado) {
    print(dado.data());
  });*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      home: ChatScreen(),
    );
  }
}
