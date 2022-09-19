class Validator {
  String? emailValidator(String? userInput) {
    String email = userInput ?? "";
    final emailPattern =
        RegExp('^([\\w\\-]+\\.)*[\\w\\- ]+@([\\w\\- ]+\\.)+([\\w\\-]{2,3})\$');
    if (email.isEmpty) {
      return "Considere digitar o seu e-mail";
    } else if (!emailPattern.hasMatch(email)) {
      return "Formato de e-mail inválido!";
    }
    return null;
  }

  String? sixDigitCodeValidator(String? userInput) {
    final code = userInput ?? "";
    final digitPattern = RegExp('^\\d\\d\\d\\d\\d\\d\$');
    if (code.isEmpty) {
      return "Considere digitar o código!";
    } else if (!digitPattern.hasMatch(code)) {
      return "Somente números";
    }
    return null;
  }

  String? newPasswordValidator(String? userInput) {
    final password = userInput ?? "";
    if (password.isEmpty) {
      return "Considere digitar algo!";
    }
    return null;
  }

  String? alfanumericPasswordValidator(String? userInput) {
    final password = userInput ?? "";
    final alfanumericPattern = RegExp(
        '^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\$*&@#])[0-9a-zA-Z\$*&@#]{8,}\$');

    if (password.isEmpty) {
      return "Campo obrigatório!";
    } else if (password.length < 8) {
      return "A senha deve ter no mínimo oito caracteres";
    } else if (!alfanumericPattern.hasMatch(password)) {
      return "Use letras, números e símbolos.";
    }
    return null;
  }
}
