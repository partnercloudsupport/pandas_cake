enum AuthStatus {
  SUCCESS,
  ERROR_EMAIL_ALREADY_IN_USE,
  ERROR_INVALID_EMAIL,
  ERROR_WRONG_PASSWORD,
  ERROR_USER_NOT_FOUND,
  ERROR_USER_DISABLED,
  ERROR_TOO_MANY_REQUESTS,
  ERROR_OPERATION_NOT_ALLOWED
}

abstract class BaseFireUtil {
  String getMessage(AuthStatus status);
  AuthStatus getStatus(String code);
}

class FireBaseUtil implements BaseFireUtil {

  String getMessage(AuthStatus status) {
    switch (status) {
      case AuthStatus.ERROR_EMAIL_ALREADY_IN_USE:
        return 'Email já em uso!';
      case AuthStatus.ERROR_INVALID_EMAIL:
        return 'Email inválido!';
      case AuthStatus.ERROR_WRONG_PASSWORD:
        return 'Password errado!';
      case AuthStatus.ERROR_USER_NOT_FOUND:
        return 'Usuário não encontrado!';
      case AuthStatus.ERROR_USER_DISABLED:
        return 'Usuário desativado!';
      case AuthStatus.ERROR_TOO_MANY_REQUESTS:
        return 'Servidor ocupado! Tento novamente mais tarde';
      case AuthStatus.ERROR_OPERATION_NOT_ALLOWED:
        return 'Operação não permitida';
      default:
        return 'Logado';
    }
  }

  AuthStatus getStatus(String code) {
    switch (code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return AuthStatus.ERROR_EMAIL_ALREADY_IN_USE;
      case 'ERROR_INVALID_EMAIL':
        return AuthStatus.ERROR_INVALID_EMAIL;
      case 'ERROR_WRONG_PASSWORD':
        return AuthStatus.ERROR_WRONG_PASSWORD;
      case 'ERROR_USER_NOT_FOUND':
        return AuthStatus.ERROR_USER_NOT_FOUND;
      case 'ERROR_USER_DISABLED':
        return AuthStatus.ERROR_USER_DISABLED;
      case 'ERROR_TOO_MANY_REQUESTS':
        return AuthStatus.ERROR_TOO_MANY_REQUESTS;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return AuthStatus.ERROR_OPERATION_NOT_ALLOWED;
      default:
        return AuthStatus.SUCCESS;
    }
  }
}