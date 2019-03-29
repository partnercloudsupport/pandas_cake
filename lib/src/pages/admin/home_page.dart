import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/blocs/bloc_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Panda\'s Cake'),
        backgroundColor: Color(0xFFFFCCCB),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              'Logout',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: bloc.signOut,
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
