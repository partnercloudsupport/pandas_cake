import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notus/notus.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

class NewOrderBloc extends BlocBase {
  NewOrderBloc({@required this.item});

  final _count = BehaviorSubject<int>.seeded(0);
  final Item item;
  NotusDocument document;
  ZefyrController _controller;
  FocusNode _focusNode;

  get getController => _controller;

  get getFocusNode => _focusNode;

  get getCount => _count.stream;

  void init() {
    document = NotusDocument.fromJson(jsonDecode(item.description));
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  @override
  void dispose() {
    _count.close();
  }

  void increment() {
    _count.sink.add(_count.value + 1);
  }

  void decrease() {
    if (_count.value > 0) {
      _count.sink.add(_count.value - 1);
    }
  }

  void addCart(context) {
    Order order = new Order();
    order.quantity = _count.value;
    order.item = item;
    Navigator.of(context).pop(order);
  }
}
