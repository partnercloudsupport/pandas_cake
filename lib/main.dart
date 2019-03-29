import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/root_page.dart';
import 'package:pandas_cake/src/blocs/root_bloc.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFCCCB),
        accentColor: Colors.brown[400],
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown[400])),
          labelStyle: new TextStyle(color: Colors.brown[400])
        )
      ),
      home: BlocProvider<RootBloc>(
          child: RootPage(),
          bloc: RootBloc()
      ),
    );
  }
}
