import 'package:flutter/material.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/admin/home/home_bloc.dart';
import 'package:pandas_cake/src/pages/login/bloc/login_bloc.dart';
import 'package:pandas_cake/src/pages/admin/home/home_page.dart';
import 'package:pandas_cake/src/pages/root_bloc.dart';
import 'package:pandas_cake/src/pages/login/page/login_page.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  RootBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<RootBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getStatus,
      builder: (context, snapshot) => _generateBody(snapshot),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _generateBody(status) {
    switch (status.data) {
      case LoginStatus.SIGN_OUT:
        return BlocProvider<LoginBloc>(
          child: LoginPage(),
          bloc: LoginBloc(
            onSignIn: bloc.signIn,
          ),
        );
      case LoginStatus.SIGN_IN:
        return BlocProvider<HomeBloc>(
          child: HomePage(),
          bloc: HomeBloc(
            onSignOut: bloc.signedOut,
          ),
        );
      default:
        return BlocProvider<LoginBloc>(
          child: LoginPage(),
          bloc: LoginBloc(
            onSignIn: bloc.signIn,
          ),
        );
    }
  }
}
