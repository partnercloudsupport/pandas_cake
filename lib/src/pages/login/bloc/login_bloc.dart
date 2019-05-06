import 'package:pandas_cake/src/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

enum FormType { login, register }

typedef OnSignIn = void Function(User user);

class LoginBloc implements BlocBase {
  LoginBloc({this.onSignIn});

  final OnSignIn onSignIn;
  final _formTypeController = BehaviorSubject<FormType>.seeded(FormType.login);

  Stream get getFormType => _formTypeController.stream;

  void moveToRegister() {
    _formTypeController.sink.add(FormType.register);
  }

  void moveToLogin() {
    _formTypeController.sink.add(FormType.login);
  }

  void dispose() {
    _formTypeController.close();
  }
}
