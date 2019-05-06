import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/root_page.dart';
import 'package:pandas_cake/src/pages/root_bloc.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: BlocProvider<RootBloc>(
          child: RootPage(),
          bloc: RootBloc()
      ),
    );
  }
}
