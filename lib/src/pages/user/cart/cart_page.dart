import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/user/cart/cart_bloc.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/utils/number_util.dart';
import 'package:pandas_cake/src/widgets/circular_progress_indicator/circular_progress_indicator.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartBloc bloc = BlocProvider.of<CartBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                  'Carrinho',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 24.0),
                )),
                Divider(),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bloc.cart.length,
                      itemBuilder: (context, index) {
                        if (bloc.cart.length > 0) {
                          return _buildListItem(context, bloc.cart[index]);
                        }
                      },
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumberUtils.numberFormat(bloc.total),
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Observação'),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (context, isLoading) {
                return FlatButton(
                  onPressed: () => bloc.sendCart(),
                  child: isLoading.data
                      ? CircularLoading(width: 30, height: 30,)
                      : Text(
                          'Finalizar pedido',
                          style: TextStyle(color: Colors.white),
                        ),
                  color: Theme.of(context).accentColor,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildListItem(context, cart) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${cart.quantity}x ${cart.item.name}',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 14.0),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                NumberUtils.numberFormat(cart.item.value * cart.quantity),
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 14.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
