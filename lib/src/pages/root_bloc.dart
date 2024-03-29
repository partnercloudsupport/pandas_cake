import 'dart:async';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

enum LoginStatus { SIGN_OUT, SIGN_IN, SIGN_IN_ADMIN }

class RootBloc implements BlocBase {
  final _repository = Repository();
  final _loginStatusController = BehaviorSubject<LoginStatus>();

  RootBloc() {
    currentUser();
  }

  Stream get getStatus => _loginStatusController.stream;

  void currentUser() {
    _repository.currentUser().then((userUid) {
      if (userUid != null) {
        _repository.findUser(User.collection, userUid).then((user) {
          if (user.isAdmin) {
            _loginStatusController.sink.add(LoginStatus.SIGN_IN_ADMIN);
          } else {
            _loginStatusController.sink.add(LoginStatus.SIGN_IN);
          }
        });
      } else {
        _loginStatusController.sink.add(LoginStatus.SIGN_OUT);
      }
    });
  }

  void signIn(User user) {
    if (user.isAdmin) {
      _loginStatusController.sink.add(LoginStatus.SIGN_IN_ADMIN);
    } else {
      _loginStatusController.sink.add(LoginStatus.SIGN_IN);
    }
  }

  void signedOut() {
    _loginStatusController.sink.add(LoginStatus.SIGN_OUT);
  }

  void dispose() {
    _loginStatusController.close();
  }
}
