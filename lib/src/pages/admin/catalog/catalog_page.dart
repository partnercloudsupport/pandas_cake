import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/admin/catalog/catalog_bloc.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item_bloc.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext parentContext) {
    CatalogBloc bloc = BlocProvider.of<CatalogBloc>(parentContext);

    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: bloc.getListStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemBuilder: (context, index) =>
                _buildListItem(parentContext, snapshot.data.documents[index], bloc),
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
          );
        },
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot document, CatalogBloc bloc) {
    Item item = Item.fromJson(document.data);
    item.id = document.documentID;
    return Card(
      elevation: 3,
      child: ListTile(
        onTap: () => _settingModalBottomSheet(context, item),
        leading: Container(
          width: 50.0,
          height: 50.0,
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right:
                  BorderSide(width: 1.0, color: Theme.of(context).accentColor),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: item.urlImage,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        subtitle: Text(bloc.numberFormat(item.value, context)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Future _settingModalBottomSheet(BuildContext context, Item item) async {
    NewItemStatus status = await Navigator.of(context).push(
      new MaterialPageRoute<NewItemStatus>(
          builder: (context) {
            return BlocProvider<NewItemBloc>(
              child: new NewItem(),
              bloc: new NewItemBloc(item: item),
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
