import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  final _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Container(
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
                        onPressed: data ? () {} : null,
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((Set states) {
                            const Set interactiveStates = {
                              MaterialState.disabled,
                            };
                            if (states.any(interactiveStates.contains)) {
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
      ),
    );
  }
}
