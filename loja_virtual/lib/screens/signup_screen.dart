import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/models/user_model.dart';

class SignUpScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void _onSuccess() {
    final context = _scaffoldKey.currentContext;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Usuário criado com sucesso!',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(
          seconds: 2,
        ),
      ),
    );
    Future.delayed(
      Duration(
        seconds: 2,
      ),
    ).then((value) => Navigator.of(context).pop());
  }

  void _onFail() {
    final context = _scaffoldKey.currentContext;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Falha ao criar usuário!',
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
        title: Text('Criar Conta'),
        centerTitle: true,
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
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Nome Completo'),
                  validator: (text) {
                    text = text.trim();
                    if (text.isEmpty || text.length < 3) return 'Nome inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
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
                    text = text.trim();
                    if (text.isEmpty || text.length < 6)
                      return 'Senha inválida';
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: 'Endereço'),
                  validator: (text) {
                    text = text.trim();
                    if (text.isEmpty) return 'Endereço inválido';
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          'name': _nameController.text.trim(),
                          'email': _emailController.text.trim(),
                          'address': _addressController.text.trim()
                        };
                        model.signUp(
                          userData: userData,
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
                      'Criar Conta',
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
