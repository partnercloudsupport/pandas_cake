import 'package:pandas_cake/src/resources/firebase_auth_provider.dart';

abstract class BaseFireUtil {
  String getMessage(AuthStatus status);
}


class FireBaseUtil implements BaseFireUtil {
  String getMessage(AuthStatus status) {
    switch (status) {
      case AuthStatus.ERROR:
        return 'Houve um erro, por favor tente novamente!';
      case AuthStatus.ERROR_EMAIL_ALREADY_IN_USE:
        return 'Email já está em uso!';
      case AuthStatus.ERROR_INVALID_EMAIL:
        return 'Email inválido!';
      case AuthStatus.SUCCESS:
        return 'Bem vindo ao Panda\'s Cake';
      default:
        return null;
    }
  }
}