import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

typedef OnAddCart = void Function(Order order);

class OrderBloc extends BlocBase {
  OrderBloc({@required this.onAddCart});

  final OnAddCart onAddCart;
  final Repository _repository = Repository();

  get getListItems => _repository.findAll(Item.collection);

  @override
  void dispose() {
  }
}