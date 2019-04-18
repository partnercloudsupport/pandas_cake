import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/resources/repository.dart';

class CatalogBloc extends BlocBase {
  final Repository _repository = Repository();
  final formatter = new NumberFormat('R\$ #,##0.00');

  Stream get getListStream => _repository.findAll('item');

  @override
  void dispose() {
  }

  String numberFormat(double value, BuildContext context) {
    return formatter.format(value);
  }

  void editItem(Item item) {

  }
}