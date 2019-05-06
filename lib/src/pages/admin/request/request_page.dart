import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/pages/admin/request/request_bloc.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/utils/date_util.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RequestBloc bloc = BlocProvider.of<RequestBloc>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: bloc.getListStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.documents.length == 0) {
            return _buildNoResult(context);
          }
          return ListView.builder(
            itemBuilder: (context, index) => _buildListItem(
                  context,
                  snapshot.data.documents[index],
                  bloc,
                ),
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
          );
        },
      ),
    );
  }

  Widget _buildNoResult(BuildContext context) {
    return Center(
      child: Text(
        'Nenhum pedido feito :/',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot document, RequestBloc bloc) {
    Order order = Order.fromJson(document.data);
    order.id = document.documentID;
    return Card(
      elevation: 3,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(order.item.urlImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              order.item.name,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
            subtitle: Text(
              order.user.name,
              style: TextStyle(fontSize: 16.0),
            ),
            trailing: Text(DateUtil.dateToString(order.dateOrder)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: order.canceled ? null : () => bloc.payed(order),
                child: Icon(
                  Icons.attach_money,
                  color: order.payed
                      ? Colors.green[300]
                      : order.canceled ? Colors.grey : Colors.black,
                ),
              ),
              FlatButton(
                onPressed: () => order.canceled ? null : bloc.delivery(order),
                child: Icon(
                  Icons.done_all,
                  color: order.delivery
                      ? Colors.blue[300]
                      : order.canceled ? Colors.grey : Colors.black,
                ),
              ),
              FlatButton(
                onPressed: order.payed || order.delivery
                    ? null
                    : () => bloc.cancel(order),
                child: Icon(
                  Icons.do_not_disturb,
                  color: order.canceled
                      ? Colors.red[300]
                      : order.delivery || order.payed
                          ? Colors.grey
                          : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
