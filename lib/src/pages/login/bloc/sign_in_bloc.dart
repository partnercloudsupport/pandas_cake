import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/pages/login/bloc/login_bloc.dart';
import 'package:pandas_cake/src/utils/firebase_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

class SignInBloc implements BlocBase {
  SignInBloc({this.onSignIn, this.onCreateAccount});

  final OnSignIn onSignIn;
  final VoidCallback onCreateAccount;
  final _repository = Repository();
  final _user = new User();
  final _formKey = new GlobalKey<FormState>();
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);

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
    setLoading(true);
    if (_validateAndSave()) {
      await _repository.signInWithEmailAndPassword(_user).then((status) {
        if (status == AuthStatus.SUCCESS) {
          _repository.currentUser().then((userUid) {
            _repository.findUser(User.collection, userUid).then(onSignIn);
          });
        } else {
          setLoading(false);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(FireBaseUtil().getMessage(status)),
          ));
        }
      });
    }
  }

  void setLoading(bool value) {
    _isLoadingController.sink.add(value);
  }

  void dispose() {
    _isLoadingController.close();
  }
}
