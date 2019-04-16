import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/calculator_bloc.dart';
import 'package:pandas_cake/src/widgets/calculator.dart';
import 'package:zefyr/zefyr.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/blocs/new_item_bloc.dart';

enum NewItemStatus { SAVED, ERROR }

class NewItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewItemState();
}

class _NewItemState extends State<NewItem> {
  NewItemBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<NewItemBloc>(context);
    bloc.init();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Novo item'),
      ),
      body: StreamBuilder(
          stream: bloc.getLoading,
          initialData: false,
          builder: (context, isLoading) =>
              isLoading.data ? _buildLoading() : _buildBody()),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: bloc.getIndex,
        builder: (containerContext, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: _buildStep(index.data),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'Voltar',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed:
                              index.data == 0 ? null : () => bloc.backStep(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            index.data == 2 ? 'Salvar' : 'Avançar',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          onPressed: index.data == 2
                              ? () => bloc.submit(context)
                              : () => bloc.nextStep(),
                          color: Theme.of(containerContext).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
      ),
    );
  }

  Widget _buildStep(int index) {
    switch (index) {
      case 0:
        return _buildPickerImage(context);
      case 1:
        return BlocProvider<CalculatorBloc>(
          child: CalculatorWidget(),
          bloc: CalculatorBloc(valuePress: bloc.setValue, value: bloc.getItem.value),
        );
      case 2:
        return _buildDescription();
      default:
        return _buildPickerImage(context);
    }
  }

  Widget _buildLoading() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Text(
            "Salvando item",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.vertical(top: new Radius.circular(10.0))),
      child: ZefyrScaffold(
        child: ZefyrTheme(
          data: ZefyrThemeData(
            toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
              color: Theme.of(context).primaryColor,
              iconColor: Theme.of(context).accentColor,
              toggleColor: Colors.white,
              disabledIconColor: Colors.grey,
            ),
          ),
          child: ZefyrEditor(
            controller: bloc.getController,
            focusNode: bloc.getFocusNode,
          ),
        ),
      ),
    );
  }

  Widget _buildPickerImage(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getImage,
      builder: (context, image) => GestureDetector(
            onTap: () => _showModalImageSheet(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: bloc.getFormKey,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) =>
                        value.isEmpty ? 'Informe um nome do produto' : null,
                    onSaved: (value) => bloc.getItem.name = value,
                    initialValue: bloc.getItem.name,
                  ),
                ),
                Expanded(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 3,
                    child: _loadImage(image.data),
                  ),
                )
              ],
            ),
          ),
    );
  }

  Widget _loadImage(File image) {
    if (image != null) {
      return Image(
        image: FileImage(image),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/camera.png',
            height: 60,
            width: 60,
          ),
          Text(
            'Fotos',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }

  void _showModalImageSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.camera_alt),
              title: new Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                bloc.openCamera();
              },
            ),
            new ListTile(
              leading: new Icon(Icons.photo),
              title: new Text('Fotos'),
              onTap: () {
                Navigator.pop(context);
                bloc.selectImage();
              },
            ),
          ],
        );
      },
    );
  }
}
