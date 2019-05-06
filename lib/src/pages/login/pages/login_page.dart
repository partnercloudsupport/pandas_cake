import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/login/bloc/sign_in_bloc.dart';
import 'package:pandas_cake/src/pages/login/pages/sign_in_page.dart';
import 'package:pandas_cake/src/pages/login/bloc/sign_up_bloc.dart';
import 'package:pandas_cake/src/pages/login/pages/sign_up_page.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Builder(
        builder: (context) => Container(
              padding: EdgeInsets.all(8.0),
              margin: MediaQuery.of(context).padding,
              child: new ListView(
                children: <Widget>[
                  _buildDisplayImage(context),
                  _body(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: bloc.getFormType,
      builder: (context, formType) => formType.data == FormType.login
          ? BlocProvider(
              child: SignInPage(),
              bloc: SignInBloc(
                onSignIn: bloc.onSignIn,
                onCreateAccount: () => bloc.moveToRegister(),
              ),
            )
          : BlocProvider(
              child: SignUpPage(),
              bloc: SignUpBloc(
                onSignIn: bloc.onSignIn,
                onLogin: () => bloc.moveToLogin(),
              ),
            ),
    );
  }

  Widget _buildDisplayImage(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 5,
      child: new DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage('assets/logo_panda.png'),
          ),
        ),
      ),
    );
  }
}
