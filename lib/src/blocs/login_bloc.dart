import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/resources/firebase_auth_provider.dart';
import 'package:pandas_cake/src/utils/firebase_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';

enum FormType { login, register }

class LoginBloc implements BlocBase {
  LoginBloc({this.onSignIn});

  final VoidCallback onSignIn;
  final Repository _repository = Repository();
  final User _user = new User();
  final _formKey = new GlobalKey<FormState>();
  final _formTypeController = BehaviorSubject<FormType>.seeded(FormType.login);
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);

  Stream get getFormType => _formTypeController.stream;

  Stream get getLoading => _isLoadingController.stream;

  User get getUser => _user;

  GlobalKey<FormState> get getFormKey => _formKey;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setLoading(false);
      return false;
    }
  }

  void validateAndSubmit(BuildContext context) async {
    AuthStatus status;
    setLoading(true);
    if (_validateAndSave()) {
      try {
        if (_formTypeController.value == FormType.login) {
          status = await _repository.signInWithEmailAndPassword(_user);
        } else {
          status = await _repository.createUserWithEmailAndPassword(_user);
        }
        if (status == AuthStatus.SUCCESS) {
          onSignIn();
        } else {
          setLoading(false);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(FireBaseUtil().getMessage(status)),
          ));
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void handleRadioSexChange(String sex) {
    _user.sex = sex;
  }

  void setLoading(bool value) {
    _isLoadingController.sink.add(value);
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    _formTypeController.sink.add(FormType.register);
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    _formTypeController.sink.add(FormType.login);
  }

  void dispose() {
    _formTypeController.close();
    _isLoadingController.close();
  }
}
