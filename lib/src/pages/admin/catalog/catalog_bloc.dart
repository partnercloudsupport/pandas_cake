import 'package:flutter/material.dart';
import 'package:pandas_cake/src/resources/firestore_provider.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/resources/repository.dart';

typedef OnSaveItem = void Function(StoreStatus status);

class CatalogBloc extends BlocBase {
  CatalogBloc({@required this.onSaveItem});

  final Repository _repository = Repository();
  final OnSaveItem onSaveItem;

  Stream get getListStream => _repository.findAll('item');

  @override
  void dispose() {
  }
}