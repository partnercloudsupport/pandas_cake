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
      body: Hero(
        tag: bloc.tag,
        child: ZefyrScaffold(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(bloc.item.urlImage),
                fit: BoxFit.cover,
              ),
            ),
            child: StreamBuilder<Object>(
              stream: bloc.opacity,
              builder: (context, opacity) {
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: opacity.hasData ? opacity.data : 0.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildSizedButton(
                                    context, () => bloc.decrease(), '-'),
                                _buildQuantityPanel(),
                                _buildSizedButton(
                                    context, () => bloc.increment(), '+'),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            _buildRichText(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
        },
      ),
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                count.hasData ? count.data.toString() : '0',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 24.0),
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
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
