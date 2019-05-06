import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

enum NavBarItemUser { ORDER, CART }

class HomeBlocUser extends BlocBase {
  HomeBlocUser({this.onSignOut});

  final VoidCallback onSignOut;
  final Repository _repository = Repository();
  final _currentIndex =
      BehaviorSubject<NavBarItemUser>.seeded(NavBarItemUser.ORDER);
  final _update = BehaviorSubject<bool>.seeded(false);
  List<Order> _cart = new List();

  Stream get getCurrentIndex => _currentIndex.stream;

  Stream get isToUpdate => _update.stream;

  int get getCartSize => _cart.length;

  get getCart => _cart;

  get getTotalCart {
    double total = 0;
    for(Order order in _cart) {
        total += order.quantity * order.item.value;
    }
    return total;
  }

  @override
  void dispose() {
    _currentIndex.close();
    _update.close();
  }

  void setIndex(int index) {
    switch (index) {
      case 0:
        _currentIndex.sink.add(NavBarItemUser.ORDER);
        break;
      case 1:
        _currentIndex.sink.add(NavBarItemUser.CART);
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

  void addToCart(Order order) async {
    if (order != null) {
      order.dateOrder = Timestamp.fromMillisecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
      order.user = await _repository.findUser(User.collection, await _repository.currentUser());
      _cart.add(order);
      if (_cart.length == 0) {
        _update.sink.add(false);
      } else {
        _update.sink.add(true);
      }
    }
  }

  void clearCart() {
    _cart.clear();
    _currentIndex.sink.add(NavBarItemUser.CART);
  }
}
