import 'package:animation/screens/login/widgets/input_field.dart';
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            InputField('Username', false, Icons.person_outline),
            InputField('Password', true, Icons.lock_outline),
          ],
        ),
      ),
    );
  }
}
