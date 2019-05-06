import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/user/home/home_bloc.dart';
import 'package:pandas_cake/src/pages/user/home/home_page.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/admin/home/home_bloc.dart';
import 'package:pandas_cake/src/pages/login/bloc/login_bloc.dart';
import 'package:pandas_cake/src/pages/admin/home/home_page.dart';
import 'package:pandas_cake/src/pages/root_bloc.dart';
import 'package:pandas_cake/src/pages/login/pages/login_page.dart';
import 'package:pandas_cake/src/widgets/circular_progress_indicator/circular_progress_indicator.dart';

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
        builder: (context, status) => _buildMaterialApp(status));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildMaterialApp(status) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFCCCB),
        accentColor: Colors.brown[400],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown[400])),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown[400])),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown[400])),
          labelStyle: new TextStyle(color: Colors.brown[400]),
        ),
      ),
      home: _generateHome(status),
    );
  }

  Widget _generateHome(status) {
    switch (status.data) {
      case LoginStatus.SIGN_OUT:
        return BlocProvider<LoginBloc>(
          child: LoginPage(),
          bloc: LoginBloc(
            onSignIn: bloc.signIn,
          ),
        );
      case LoginStatus.SIGN_IN_ADMIN:
        return BlocProvider<HomeBloc>(
          child: HomePage(),
          bloc: HomeBloc(
            onSignOut: bloc.signedOut,
          ),
        );
      case LoginStatus.SIGN_IN:
        return BlocProvider<HomeBlocUser>(
          child: HomePageUser(),
          bloc: HomeBlocUser(onSignOut: bloc.signedOut),
        );
      default:
        return CircularLoading();
    }
  }
}
