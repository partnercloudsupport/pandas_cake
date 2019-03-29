import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/resources/repository.dart';

class HomeBloc extends BlocBase {
  HomeBloc({this.onSignOut});

  final VoidCallback onSignOut;
  final Repository _repository = Repository();

  void signOut() async {
    try {
      await _repository.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
  }
}