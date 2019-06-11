import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/resources/firestore_provider.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/admin/catalog/catalog_bloc.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item_bloc.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/pages/admin/item/new_item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pandas_cake/src/utils/number_util.dart';
import 'package:pandas_cake/src/widgets/circular_progress_indicator/circular_progress_indicator.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext parentContext) {
    CatalogBloc bloc = BlocProvider.of<CatalogBloc>(parentContext);

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
                  parentContext,
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
        'Nenhum item cadastrado ainda :(',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
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
        onTap: () => _settingModalBottomSheet(context, item, bloc),
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
            placeholder: (context, url) => CircularLoading(
                  width: 20.0,
                  height: 20.0,
                  color: Theme.of(context).accentColor,
                ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        subtitle: Text(NumberUtils.numberFormat(item.value)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Future _settingModalBottomSheet(
      BuildContext context, Item item, CatalogBloc bloc) async {
    StoreStatus status = await Navigator.of(context).push(
      new MaterialPageRoute<StoreStatus>(
          builder: (context) {
            return BlocProvider<NewItemBloc>(
              child: new NewItem(),
              bloc: new NewItemBloc(item: item),
            );
          },
          fullscreenDialog: true),
    );
    bloc.onSaveItem(status);
  }
}
