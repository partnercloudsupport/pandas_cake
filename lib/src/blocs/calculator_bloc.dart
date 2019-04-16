import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CalculatorBloc extends BlocBase {
  CalculatorBloc({@required this.valuePress, @required this.value});

  double value;
  final _moneyMaskController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');
  Function(double) valuePress;

  MoneyMaskedTextController get getMoneyMaskedController => _moneyMaskController;

  void init() {
    _moneyMaskController.updateValue(value);
  }

  @override
  void dispose() {
  }

  void buttonPressed(String buttonText) {
    List<String> textList = value
        .toStringAsFixed(2)
        .replaceAll('.', '')
        .split('')
        .toList(growable: true);

    if (buttonText == 'DEL' || buttonText.isEmpty) {
      textList.removeAt(textList.length - 1);
    } else {
      textList.insert(textList.length, buttonText);
    }

    textList.insert(textList.length - 2, ',');
    value = double.parse(textList.join('').replaceAll(',', '.'));
    _moneyMaskController.updateValue(value);
    valuePress(value);
  }
}
