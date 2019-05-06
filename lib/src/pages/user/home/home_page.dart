import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/user/cart/cart_bloc.dart';
import 'package:pandas_cake/src/pages/user/cart/cart_page.dart';
import 'package:pandas_cake/src/pages/user/home/home_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/order_bloc.dart';
import 'package:pandas_cake/src/pages/user/order/order_page.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/widgets/circular_progress_indicator/circular_progress_indicator.dart';

class HomePageUser extends StatefulWidget {
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  HomeBlocUser bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomeBlocUser>(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Panda\'s Cake'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => bloc.signOut(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: bloc.getCurrentIndex,
        builder: (context, navBarItem) {
          switch (navBarItem.data) {
            case NavBarItemUser.ORDER:
              return BlocProvider(
                child: OrderPage(),
                bloc: OrderBloc(onAddCart: (order) => bloc.addToCart(order)),
              );
            case NavBarItemUser.CART:
              return StreamBuilder(
                stream: bloc.isToUpdate,
                initialData: false,
                builder: (context, update) {
                  if(update.data || bloc.getCartSize == 0) {
                    return _buildCartPage(context);
                  } else {
                    return CircularLoading(color: Theme.of(context).accentColor,);
                  }
                }
              );
              break;
            default:
              return CircularLoading(color: Theme.of(context).accentColor,);
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildCartPage(BuildContext context) {
     if (bloc.getCartSize > 0) {
      return BlocProvider(
        child: CartPage(),
        bloc: CartBloc(
          total: bloc.getTotalCart,
          cart: bloc.getCart,
          onSend: () {
            bloc.clearCart();
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Pedido realizado com sucesso :D')));
          },
        ),
      );
    } else {
      return Center(child: Text('Seu carrinho está vazio :/'));
    }
  }

  Widget _buildBottomNavigation() {
    return StreamBuilder(
      stream: bloc.getCurrentIndex,
      builder: (context, index) => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.import_contacts),
                title: Container(height: (0.0)),
              ),
              BottomNavigationBarItem(
                icon: StreamBuilder(
                    stream: bloc.isToUpdate,
                    builder: (context, update) {
                      if (update.hasData && bloc.getCartSize > 0) {
                        return _buildIconWithNotch();
                      } else {
                        return Icon(Icons.local_grocery_store);
                      }
                    }),
                title: Container(height: (0.0)),
              ),
            ],
            currentIndex: index.data == null ? 0 : index.data.index,
            onTap: bloc.setIndex,
          ),
    );
  }

  Stack _buildIconWithNotch() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Icon(Icons.local_grocery_store),
        Positioned(
          top: -2.0,
          right: -5.0,
          child: Container(
            width: 14.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent,
            ),
            child: Center(
                child: Text(
              '${bloc.getCartSize}',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ],
    );
  }
}
