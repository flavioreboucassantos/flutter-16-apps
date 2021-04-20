import 'dart:io';

import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  Future<bool> _sendMessage({String text, PickedFile pickedFile}) async {
    final User user = await _getUser();

    if (user == null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
        content: Text('Não foi possível fazer o login. Tente novamente!'),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'time': Timestamp.now(),
    };

    if (pickedFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(
              UniqueKey().toString() + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(pickedFile.path));

      setState(() {
        _isLoading = true;
      });

      TaskSnapshot taskSnapshot = await task.whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
    return true;
  }

  Widget _getWidgetTitle() {
    final titleText =
        _currentUser != null ? 'Olá ${_currentUser.displayName}' : 'Chat App';
    return Text(
      titleText,
    );
  }

  void _exitToApp() {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text('Você saiu com sucesso!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _getWidgetTitle(),
          centerTitle: true,
          elevation: 0,
          actions: [
            _currentUser != null
                ? IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: _exitToApp,
                  )
                : Container(),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents =
                          snapshot.data.docs.reversed.toList();
                      return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(documents[index].data(),
                              documents[index].data()['uid'] == _currentUser?.uid);
                        },
                      );
                  }
                },
              ),
            ),
            _isLoading ? LinearProgressIndicator() : Container(),
            TextComposer(_sendMessage),
          ],
        ));
  }
}
