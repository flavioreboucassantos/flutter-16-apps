import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'CRIAR CONTA',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                print('validator email');
                if (!EmailValidator.validate(text)) return 'E-mail inválido';
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: 'Senha'),
              obscureText: true,
              validator: (text) {
                if (text.isEmpty || text.length < 6) return 'Senha inválida';
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {},
                child: Text(
                  'Esqueci minha senha',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 44.0,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
