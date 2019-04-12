import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

enum NavBarItem { ORDERS, CATALOG }

class HomeBloc extends BlocBase {
  HomeBloc({this.onSignOut});

  final VoidCallback onSignOut;
  final Repository _repository = Repository();
  final _currentIndex = BehaviorSubject<NavBarItem>.seeded(NavBarItem.ORDERS);

  Stream get getCurrentIndex => _currentIndex.stream;

  void setIndex(int index) {
    switch(index) {
      case 0:
        _currentIndex.sink.add(NavBarItem.ORDERS);
        break;
      case 1:
        _currentIndex.sink.add(NavBarItem.CATALOG);
        break;
    }
  }

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
    _currentIndex.close();
  }
}