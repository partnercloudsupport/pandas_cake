import 'package:flutter/material.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/pages/login/bloc/login_bloc.dart';
import 'package:pandas_cake/src/resources/firestore_provider.dart';
import 'package:pandas_cake/src/utils/firebase_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

class SignUpBloc implements BlocBase {
  SignUpBloc({this.onSignIn, this.onLogin});

  final OnSignIn onSignIn;
  final VoidCallback onLogin;
  final _repository = Repository();
  final _user = new User();
  final _formKey = new GlobalKey<FormState>();
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  final _radioSexController = BehaviorSubject<String>.seeded('M');

  Stream get getLoading => _isLoadingController.stream;

  Stream get getSexChange => _radioSexController.stream;

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
      _repository.createUserWithEmailAndPassword(_user).then((authStatus) {
        if (authStatus == AuthStatus.SUCCESS) {
          _repository
              .save(User.collection, _user.uid, _user.toJson())
              .then((status) {
            if (status == StoreStatus.SUCCESS) {
              onSignIn(_user);
            } else {
              setLoading(false);
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('Error ao salvar o usuário'),
              ));
            }
          });
        } else {
          setLoading(false);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(FireBaseUtil().getMessage(authStatus)),
          ));
        }
      });
    }
  }

  void handleRadioSexChange(String sex) {
    _user.sex = sex;
    _radioSexController.sink.add(sex);
  }

  void setLoading(bool value) {
    _isLoadingController.sink.add(value);
  }

  void dispose() {
    _isLoadingController.close();
    _radioSexController.close();
  }
}
