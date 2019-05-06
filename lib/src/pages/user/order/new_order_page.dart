import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/user/order/new_order_bloc.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:zefyr/zefyr.dart';

class NewOrderPage extends StatefulWidget {
  @override
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  NewOrderBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<NewOrderBloc>(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(bloc.item.name),
      ),
      body: ZefyrScaffold(
        child: ListView(
          children: <Widget>[
            _buildHeaderImage(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSizedButton(context, () => bloc.decrease(), '-'),
                  _buildQuantityPanel(),
                  _buildSizedButton(context, () => bloc.increment(), '+'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: _buildRichText(context),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
          stream: bloc.getCount,
          builder: (context, count) {
            return FloatingActionButton(
              onPressed: () => count.data > 0 ? bloc.addCart(context) : null,
              child: Icon(Icons.local_grocery_store),
              backgroundColor:
                  count.data == 0 ? Colors.grey : Theme.of(context).accentColor,
            );
          }),
    );
  }

  Container _buildHeaderImage() {
    return Container(
      height: 240,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(_expandedImage()),
        child: Hero(
          tag: 'itemImage',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(bloc.item.urlImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  MaterialPageRoute _expandedImage() {
    return MaterialPageRoute(
      builder: (builder) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: 'itemImage',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(bloc.item.urlImage),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ZefyrField _buildRichText(BuildContext context) {
    return ZefyrField(
      height: 250,
      controller: bloc.getController,
      focusNode: bloc.getFocusNode,
      enabled: false,
      autofocus: false,
      physics: ClampingScrollPhysics(),
      decoration: InputDecoration(
        labelText: 'Descrição',
        labelStyle: TextStyle(
          fontSize: 24.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Padding _buildQuantityPanel() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
      child: StreamBuilder(
        stream: bloc.getCount,
        builder: (context, count) {
          return Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).accentColor,
              ),
            ),
            child: Center(
              child: Text(
                count.data.toString(),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 24.0
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox _buildSizedButton(context, onPress, text) {
    return SizedBox(
      width: 60,
      height: 60,
      child: FlatButton(
        onPressed: onPress,
        color: Theme.of(context).primaryColor,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
