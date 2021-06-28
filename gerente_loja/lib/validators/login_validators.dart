import 'dart:async';

import 'package:email_validator/email_validator.dart';

class LoginValidators {
  final StreamTransformer<String, String> validateEmail =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (EmailValidator.validate(data))
        sink.add(data);
      else
        sink.addError('Insira um e-mail válido');
    },
  );

  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (data.length > 5)
        sink.add(data);
      else
        sink.addError('Senha inválida, deve conter pelo menos 6 caracteres');
    },
  );
}
