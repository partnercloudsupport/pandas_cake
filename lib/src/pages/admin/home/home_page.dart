import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/admin/request/request_bloc.dart';
import 'package:pandas_cake/src/pages/admin/request/request_page.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/admin/home/home_bloc.dart';
import 'package:pandas_cake/src/pages/admin/catalog/catalog_bloc.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item_bloc.dart';
import 'package:pandas_cake/src/pages/admin/catalog/catalog_page.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item_page.dart';
import 'package:pandas_cake/src/resources/firestore_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);

    return new Scaffold(
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
            case NavBarItem.ORDERS:
              return BlocProvider(
                child: RequestPage(),
                bloc: RequestBloc(),
              );
            case NavBarItem.CATALOG:
              return BlocProvider(
                child: CatalogPage(),
                bloc: CatalogBloc(
                  onSaveItem: (status) => _showSnackBar(context, status),
                ),
              );
            default:
              return BlocProvider(
                child: RequestPage(),
                bloc: RequestBloc(),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: _buildBottomNavigation(bloc),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _settingModalBottomSheet(context),
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  Future _settingModalBottomSheet(context) async {
    StoreStatus status = await Navigator.of(context).push(
      new MaterialPageRoute<StoreStatus>(
          builder: (context) {
            return BlocProvider<NewItemBloc>(
              child: new NewItem(),
              bloc: new NewItemBloc(),
            );
          },
          fullscreenDialog: true),
    );
    _showSnackBar(context, status);
  }

  Widget _buildBottomNavigation(HomeBloc bloc) {
    return StreamBuilder(
      stream: bloc.getCurrentIndex,
      builder: (context, index) => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.loyalty),
                title: Container(height: (0.0)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.import_contacts),
                title: Container(height: (0.0)),
              ),
            ],
            currentIndex: index.data == null ? 0 : index.data.index,
            onTap: bloc.setIndex,
          ),
    );
  }

  void _showSnackBar(BuildContext context, StoreStatus status) {
    if (status == StoreStatus.SUCCESS) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text("Item salvo com sucesso!"),
        ),
      );
    }
  }
}
