import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:pandas_cake/services/auth.dart';
import 'package:pandas_cake/pages/users/home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_SIGN_IN,
  SIGN_IN
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.NOT_SIGN_IN;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userUid) {
      setState(() {
        _authStatus = userUid == null ? AuthStatus.NOT_SIGN_IN : AuthStatus.SIGN_IN;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.SIGN_IN;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.NOT_SIGN_IN;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_SIGN_IN:
        return new LoginPage(auth: widget.auth, onSignedIn: _signedIn,);
      case AuthStatus.SIGN_IN:
        return new HomePage(auth: widget.auth, onSignOut: _signedOut,);
      default:
        return new LoginPage(auth: widget.auth, onSignedIn: _signedIn,);
    }
  }
}