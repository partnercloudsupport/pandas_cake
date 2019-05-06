import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/models/user.dart';

class Order {
  static final String collection = 'order';
  String id;
  Timestamp dateOrder;
  Timestamp dateDelivery;
  Timestamp datePayed;
  Timestamp dateCanceled;
  int quantity;
  bool payed = false;
  bool delivery = false;
  bool canceled = false;
  User user;
  Item item;

  Order();

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quantity = json['quantity'] as int,
        dateOrder = json['dateOrder'],
        dateDelivery = json['dateDelivery'],
        datePayed = json['datePayed'],
        payed = json['payed'],
        delivery = json['delivery'],
        canceled = json['canceled'],
        dateCanceled = json['dateCanceled'],
        user = User.fromJson(new Map<String, dynamic>.from(json['user'])),
        item = Item.fromJson(new Map<String, dynamic>.from(json['item']));

  Map<String, dynamic> toJson() => {
    'id': id,
    'quantity': quantity,
    'dateOrder': dateOrder,
    'dateDelivery': dateDelivery,
    'datePayed': datePayed,
    'payed': payed,
    'delivery': delivery,
    'canceled': canceled,
    'dateCanceled' : dateCanceled,
    'user': user.toJson(),
    'item': item.toJson()
  };
}