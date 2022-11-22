class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    'INVALID_PASSWORD': 'Senha informada não confere.',
    'USER_DISABLED': 'A conta do usuário foi desabilitada.',
    'NO_ELEMENT': 'CPF não encontrado!',
    'ERRO': 'Hum... isto não funcionou!',
    'Bad state: No element': 'Usuário não encontrado!',
    'user-not-found': 'Não existe nenhum usuário cadastrado com esse CPF.',
    'invalid-email': 'Email inválido!',
    'user-disabled': 'Usuário desabilitado!',
    'email-already-in-use':
        'Este email já está sendo utilizado por outro usuário.',
    'operation-not-allowed': 'Operação não permitida!',
    'weak-password': 'Senha fraca, tente usar outra!',
    'wrong-password': 'Senha incorreta!',
    'too-many-requests': 'Muitas solicitações feitas, aguarde um momento...',
  };

  final String key;

  AuthException(this.key);

  static String translateException(String code) {
    return errors[code] ?? code;
  }

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação.';
  }
}
