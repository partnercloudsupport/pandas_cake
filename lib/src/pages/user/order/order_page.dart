import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pandas_cake/src/pages/user/order/order_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/order_page_item.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderBloc bloc = BlocProvider.of<OrderBloc>(context);
    bloc.init();
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _buildHeader(context, bloc)),
        Expanded(flex: 10, child: _buildBody(bloc)),
      ],
    );
  }

  Widget _buildHeader(context, OrderBloc bloc) {
    return Container(
      child: Row(
        children: <Widget>[
          StreamBuilder(
            stream: bloc.isToShowbutton,
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
                    onPressed: () => bloc.backToBegin(),
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

  Widget _buildBody(OrderBloc bloc) {
    return Container(
      child: StreamBuilder(
        stream: bloc.getListItems,
        builder: (streamContext, AsyncSnapshot<QuerySnapshot> items) {
          if (!items.hasData) {
            return CircularProgressIndicator();
          }
          return PageView.builder(
            controller: bloc.pageController,
            itemCount: items.data.documents.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: bloc.currentPage,
                  builder: (context, currentPage) {
                    bool active = currentPage.data == index;
                    return OrderPageItem(
                      document: items.data.documents[index],
                      onSaveItem: bloc.onAddCart,
                      active: active,
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
