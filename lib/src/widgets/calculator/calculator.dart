import 'package:flutter/material.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/widgets/calculator/calculator_bloc.dart';

class CalculatorWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorWidget> {
  CalculatorBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CalculatorBloc>(context);
    bloc.init();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: TextField(
              controller: bloc.getMoneyMaskedController,
              style: TextStyle(
                  fontSize: 46.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none, hintText: 'R\$ 0,00'),
              textAlign: TextAlign.center,
              enabled: false,
            ),
          ),
        ),
        Divider(),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
              ],
            ),
            Row(
              children: <Widget>[
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
              ],
            ),
            Row(
              children: <Widget>[
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
              ],
            ),
            Row(
              children: <Widget>[
                _buildButton(''),
                _buildButton('0'),
                _buildButton('DEL'),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: OutlineButton(
        padding: EdgeInsets.all(24.0),
        onPressed: () =>
        buttonText.isEmpty ? null : bloc.buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

}