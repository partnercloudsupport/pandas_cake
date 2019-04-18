import 'package:flutter/material.dart';

class LoginRaisedButton extends StatelessWidget {
  LoginRaisedButton({@required this.isLoading, @required this.onPress, @required this.label});

  final bool isLoading;
  final VoidCallback onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: ButtonTheme(
          height: 45.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: onPress,
            child: !isLoading
                ? Text(label, style: TextStyle(fontSize: 20.0))
                : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
    );
  }
}