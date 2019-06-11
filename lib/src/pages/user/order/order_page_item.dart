import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/pages/user/order/new_order_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/new_order_page.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/utils/number_util.dart';

typedef OnSaveItem = void Function(Order order);

class OrderPageItem extends StatelessWidget {
  OrderPageItem({this.document, this.onSaveItem, this.active});

  final document;
  final OnSaveItem onSaveItem;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 50 : 100;

    Item item = Item.fromJson(document.data);

    return GestureDetector(
      onTap: () => _settingModalBottomSheet(context, item),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: CachedNetworkImageProvider(item.urlImage),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: blur,
              offset: Offset(offset, offset),
            )
          ],
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  NumberUtils.numberFormat(item.value),
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  item.name,
                  style: TextStyle(color: Colors.white, fontSize: 23.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _settingModalBottomSheet(context, Item item) async {
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
    onSaveItem(order);
  }
}
