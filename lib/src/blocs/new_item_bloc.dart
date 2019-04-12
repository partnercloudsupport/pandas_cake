import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/pages/admin/new_item.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

class NewItemBloc extends BlocBase {
  final Repository _repository = Repository();
  final Item _item = new Item();
  final _formKey = new GlobalKey<FormState>();
  final _imageController = BehaviorSubject<File>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);
  final _stepIndexController = BehaviorSubject<int>.seeded(0);
  final document = new NotusDocument();
  ZefyrController _controller;
  FocusNode _focusNode;

  get getIndex => _stepIndexController.stream;

  get getImage => _imageController.stream;

  get getLoading => _loadingController.stream;

  get getItem => _item;

  get getFormKey => _formKey;

  get getController => _controller;

  get getFocusNode => _focusNode;

  @override
  void dispose() {
    _imageController.close();
    _loadingController.close();
    _stepIndexController.close();
  }

  void init() {
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  void selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _imageController.sink.add(image);
    _item.image = image;
  }

  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _imageController.sink.add(image);
    _item.image = image;
  }

  void submit(context) async {
    _loadingController.sink.add(true);
    _repository.uploadImage(_item.image).then((url) {
      _item.urlImage = url;
      _item.description = jsonEncode(document.toJson());
      _repository
          .save(_item.collection, null, _item.toJson())
          .then((status) => Navigator.of(context).pop(NewItemStatus.SAVED));
    });
  }

  bool validate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      _loadingController.sink.add(false);
      return false;
    }
  }

  void nextStep() {
    switch (_stepIndexController.value) {
      case 0:
        if (validate()) {
          _stepIndexController.sink.add(_stepIndexController.value + 1);
        }
        break;
      default:
        _stepIndexController.sink.add(_stepIndexController.value + 1);
    }
  }

  void backStep() {
    if (_stepIndexController.value > 0) {
      _stepIndexController.sink.add(_stepIndexController.value - 1);
    }
  }

  void setValue(double value) {
    _item.value = value;
  }
}
