import 'package:flutter/material.dart';

typedef SaveValueCallBack = void Function(String value);

class LoginTextFormField extends StatelessWidget {
  LoginTextFormField(
      {@required this.label, @required this.error, @required this.onSave, this.obscureText = false});

  final String label;
  final String error;
  final bool obscureText;
  final SaveValueCallBack onSave;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: label
      ),
      validator: (value) => value.isEmpty ? error : null,
      onSaved: (value) => onSave(value),
      obscureText: obscureText,
    );
  }
}
