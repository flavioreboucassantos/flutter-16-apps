import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loja_virtual/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void _onSuccess() {
    Navigator.of(_scaffoldKey.currentContext).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        content: Text(
          'Falha ao entrar!',
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(
          seconds: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                'CRIAR CONTA',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (!EmailValidator.validate(text))
                      return 'E-mail inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return 'Senha inválida';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      if (_emailController.text.trim().isEmpty)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Insira seu e-mail para recuperação!',
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      else if (!EmailValidator.validate(
                          _emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'E-mail inválido para recuperação!',
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      } else {
                        model.recoverPass(_emailController.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Confira seu e-mail!',
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                    },
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
                      if (_formKey.currentState.validate()) {
                        model.signIn(
                          email: _emailController.text.trim(),
                          pass: _passController.text.trim(),
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      }
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
          );
        },
      ),
    );
  }
}
