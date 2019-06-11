import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

typedef OnAddCart = void Function(Order order);

class OrderBloc extends BlocBase {
  OrderBloc({@required this.onAddCart});

  final OnAddCart onAddCart;
  final Repository _repository = Repository();
  final _showBackButton = BehaviorSubject.seeded(false);
  final _pageController = new PageController(viewportFraction: 0.8);
  final _currentPage = BehaviorSubject.seeded(0);

  get getListItems => _repository.findAll(Item.collection);
  get isToShowbutton => _showBackButton.stream;
  get currentPage => _currentPage.stream;
  get pageController => _pageController;

  void init() {
    _pageController.addListener(() {
      int next = _pageController.page.round();

      if (_currentPage.value != next) {
        _currentPage.sink.add(next);
      }

      if (_currentPage.value > 0) {
        _showBackButton.sink.add(true);
      } else {
        _showBackButton.sink.add(false);
      }
    });
  }

  @override
  void dispose() {
    _showBackButton.close();
    _currentPage.close();
  }

  void backToBegin() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
