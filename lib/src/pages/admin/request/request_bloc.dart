import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandas_cake/src/models/order.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

class RequestBloc extends BlocBase{
  final Repository _repository = Repository();

  get getListStream => _repository.findAll('order');

  @override
  void dispose() {
  }

  void cancel(Order order) {
    if(order.canceled) {
      order.dateCanceled = null;
    } else {
      order.dateCanceled = Timestamp.fromMillisecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
    }
    order.canceled = !order.canceled;
    _repository.save(Order.collection, order.id, order.toJson());
  }

  void payed(Order order) {
    if(order.payed) {
      order.datePayed = null;
    } else {
      order.datePayed = Timestamp.fromMillisecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
    }
    order.payed = !order.payed;
    _repository.save(Order.collection, order.id, order.toJson());
  }

  void delivery(Order order) {
    if(order.delivery) {
      order.dateDelivery = null;
    } else {
      order.dateDelivery = Timestamp.fromMillisecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
    }
    order.delivery = !order.delivery;
    _repository.save(Order.collection, order.id, order.toJson());
  }
}