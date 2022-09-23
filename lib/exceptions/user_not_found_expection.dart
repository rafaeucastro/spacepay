class UserNotFoundException implements Exception {
  static const Map<String, String> errors = {
    'NO_ELEMENT': 'CPF não encontrado!',
    'Bad state: No element': 'Usuário não encontrado!',
  };

  final String key;

  UserNotFoundException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Erro Inesperado!';
  }
}
