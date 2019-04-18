import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

enum FormType { login, register }

class LoginBloc implements BlocBase {
  LoginBloc({this.onSignIn});

  final VoidCallback onSignIn;
  final User _user = new User();
  final _formTypeController = BehaviorSubject<FormType>.seeded(FormType.login);
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);

  Stream get getFormType => _formTypeController.stream;

  Stream get getLoading => _isLoadingController.stream;

  User get getUser => _user;

  void setLoading(bool value) {
    _isLoadingController.sink.add(value);
  }

  void moveToRegister() {
    _formTypeController.sink.add(FormType.register);
  }

  void moveToLogin() {
    _formTypeController.sink.add(FormType.login);
  }

  void dispose() {
    _formTypeController.close();
    _isLoadingController.close();
  }
}
