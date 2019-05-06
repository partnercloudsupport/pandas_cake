import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends BlocBase {
  CartBloc({@required this.cart, @required this.total, @required this.onSend});

  final _repository = Repository();
  final List<Order> cart;
  final double total;
  final VoidCallback onSend;
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  get loadingStream => _loadingController.stream;

  @override
  void dispose() {
    _loadingController.close();
  }

  void sendCart() {
    List<Map<String, dynamic>> jsonList = new List();
    _loadingController.sink.add(true);
    for (Order order in cart) {
      jsonList.add(order.toJson());
    }
    _repository.saveList(Order.collection, jsonList).then((status) {
      _loadingController.sink.add(false);
      onSend();
    });
  }
}
