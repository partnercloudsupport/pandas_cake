import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/pages/user/order/new_order_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/new_order_page.dart';
import 'package:pandas_cake/src/pages/user/order/order_bloc.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/utils/number_util.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderBloc bloc = BlocProvider.of<OrderBloc>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: bloc.getListItems,
        builder: (streamContext, AsyncSnapshot<QuerySnapshot> items) {
          if (!items.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: items.data.documents.length,
            itemBuilder: (context, index) =>
                _buildItemList(context, items.data.documents[index], bloc),
          );
        },
      ),
    );
  }

  Widget _buildItemList(context, DocumentSnapshot document, OrderBloc bloc) {
    Item item = Item.fromJson(document.data);
    return Card(
      elevation: 4.0,
      child: ListTile(
        onTap: () => _settingModalBottomSheet(context, item, bloc),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(item.urlImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(item.name),
        subtitle: Text(NumberUtils.numberFormat(item.value)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Future _settingModalBottomSheet(context, Item item, OrderBloc bloc) async {
    Order order = await Navigator.of(context).push(
      new MaterialPageRoute<Order>(
        builder: (context) {
          return BlocProvider<NewOrderBloc>(
            child: NewOrderPage(),
            bloc: NewOrderBloc(item: item),
          );
        },
        fullscreenDialog: true,
      ),
    );
    bloc.onAddCart(order);
  }
}
