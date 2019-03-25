import 'package:flutter/material.dart';
import 'package:pandas_cake/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});

  final BaseAuth auth;
  final VoidCallback onSignOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Panda\'s Cake'),
        backgroundColor: Colors.pink[200],
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              'Logout',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: _signOut,
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text(
            'Welcome to home',
            style: new TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
