import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/screens/home_screen.dart';
import 'package:gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erro'),
              content: Text('Você não possui os privilégios necessários'),
            ),
          );
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.pinkAccent,
                  ),
                );
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
              default:
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.store_mall_directory,
                          color: Colors.pinkAccent,
                          size: 160,
                        ),
                        InputField(
                          icon: Icons.person_outline,
                          hint: 'Usuário',
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        InputField(
                          icon: Icons.lock_outline,
                          hint: 'Senha',
                          obscure: true,
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                        ),
                        SizedBox(height: 32),
                        StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              bool data = snapshot.data ?? false;
                              return SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: data ? _loginBloc.submit : null,
                                  child: Text(
                                    'Entrar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (Set states) {
                                      const Set interactiveStates = {
                                        MaterialState.disabled,
                                      };
                                      if (states
                                          .any(interactiveStates.contains)) {
                                        return Colors.pinkAccent.withAlpha(140);
                                      }
                                      return Colors.pinkAccent;
                                    }),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                );
            }
          }),
    );
  }
}
