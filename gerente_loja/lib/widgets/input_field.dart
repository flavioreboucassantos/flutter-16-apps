import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  InputField({
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.stream,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent),
              ),
              contentPadding: EdgeInsets.only(
                left: 5,
                right: 30,
                bottom: 30,
                top: 30,
              ),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            style: TextStyle(color: Colors.white),
            obscureText: obscure,
          );
        });
  }
}
