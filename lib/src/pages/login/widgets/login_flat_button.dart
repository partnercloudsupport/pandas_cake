import 'package:flutter/material.dart';

class LoginFlatButton extends StatelessWidget {
  LoginFlatButton({@required this.onPress, @required this.label});

  final VoidCallback onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: new FlatButton(
        onPressed: onPress,
        child: new Text(
          label,
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}