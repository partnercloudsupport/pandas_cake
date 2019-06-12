import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pandas_cake/src/pages/user/order/order_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/order_page_item.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

OrderBloc _bloc;

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
@override
  void initState() {
    _bloc = BlocProvider.of<OrderBloc>(context);
    _bloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _buildHeader()),
        Expanded(flex: 10, child: _buildBody()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Row(
        children: <Widget>[
          StreamBuilder(
            stream: _bloc.isToShowbutton,
            builder: (context, show) {
              return AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: (show.hasData && show.data) ? 1.0 : 0.0,
                child: SizedBox(
                  height: double.infinity,
                  child: FlatButton(
                    child: Icon(
                      Icons.chevron_left,
                      size: 32,
                    ),
                    onPressed: () => _bloc.backToBegin(),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Text(
              'Panda\'s Cake',
              style: TextStyle(
                fontSize: 26,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: StreamBuilder(
        stream: _bloc.getListItems,
        builder: (streamContext, AsyncSnapshot<QuerySnapshot> items) {
          if (!items.hasData) {
            return CircularProgressIndicator();
          }
          return PageView.builder(
            controller: _bloc.pageController,
            itemCount: items.data.documents.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                stream: _bloc.currentPage,
                builder: (context, currentPage) {
                  bool active = currentPage.data == index;
                  return OrderPageItem(
                    document: items.data.documents[index],
                    onSaveItem: _bloc.onAddCart,
                    active: active,
                    index: index.toString(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
