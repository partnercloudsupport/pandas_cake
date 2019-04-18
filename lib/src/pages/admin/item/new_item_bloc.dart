import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/models/item.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:image_picker/image_picker.dart';

class NewItemBloc extends BlocBase {
  NewItemBloc({this.item});

  final Repository _repository = Repository();
  final _formKey = new GlobalKey<FormState>();
  final _imageController = BehaviorSubject<File>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);
  final _loadingImgController = BehaviorSubject<bool>.seeded(false);
  final _stepIndexController = BehaviorSubject<int>.seeded(0);
  final document = new NotusDocument();
  Item item;
  ZefyrController _controller;
  FocusNode _focusNode;

  get getIndex => _stepIndexController.stream;

  get getImage => _imageController.stream;

  get getLoading => _loadingController.stream;

  get getLoadingImg => _loadingImgController.stream;

  Item get getItem => item;

  get getFormKey => _formKey;

  get getController => _controller;

  get getFocusNode => _focusNode;

  @override
  void dispose() {
    _imageController.close();
    _loadingController.close();
    _stepIndexController.close();
    _loadingImgController.close();
  }

  void init() {
    if (item == null) {
      item = new Item();
    } else {
      _loadImage();
    }
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  void selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _imageController.sink.add(image);
    item.image = image;
  }

  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _imageController.sink.add(image);
    item.image = image;
  }

  void submit(context) async {
    _loadingController.sink.add(true);
    await _repository
        .uploadImage(item.image)
        .then((url) => item.urlImage = url)
        .catchError((error) => print('ERROR HANDLE: $error'));

    item.description = jsonEncode(document.toJson());
    _repository
        .save(item.collection, item.id, item.toJson())
        .then((status) => Navigator.of(context).pop(status));
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
    item.value = value;
  }

  void _loadImage() async {
    _loadingImgController.sink.add(true);
    var response = await get(item.urlImage);
    var documentDirectory = await getApplicationDocumentsDirectory();
    final RegExp regex = RegExp('([^?/]*\.(jpg))');
    final String fileName = regex.stringMatch(item.urlImage);
    File file = new File(join(documentDirectory.path, fileName));
    file.writeAsBytesSync(response.bodyBytes);
    item.image = file;
    _imageController.sink.add(file);
    _loadingImgController.sink.add(false);
  }
}
