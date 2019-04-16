import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/blocs/bloc_home.dart';
import 'package:pandas_cake/src/blocs/catalog_bloc.dart';
import 'package:pandas_cake/src/blocs/new_item_bloc.dart';
import 'package:pandas_cake/src/pages/admin/catalog_page.dart';
import 'package:pandas_cake/src/pages/admin/new_item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Panda\'s Cake'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.person),
            onPressed: () => bloc.signOut(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: bloc.getCurrentIndex,
        builder: (context, navBarItem) {
          switch (navBarItem.data) {
            case NavBarItem.ORDERS:
              return Center(child: Text('ORDER'));
            case NavBarItem.CATALOG:
              return BlocProvider(child: CatalogPage(), bloc: CatalogBloc());
            default:
              return Center(child: Text('ORDER'));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
              onPressed: () => _settingModalBottomSheet(context),
              child: Icon(Icons.add),
              elevation: 2.0,
            ),
      ),
      bottomNavigationBar: StreamBuilder(
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
      ),
    );
  }

  Future _settingModalBottomSheet(context) async {
    NewItemStatus status = await Navigator.of(context).push(
      new MaterialPageRoute<NewItemStatus>(
          builder: (context) {
            return BlocProvider<NewItemBloc>(
              child: new NewItem(),
              bloc: new NewItemBloc(),
            );
          },
          fullscreenDialog: true),
    );
    if (status == NewItemStatus.SAVED) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text("Item salvo com sucesso!"),
        ),
      );
    }
  }
}
