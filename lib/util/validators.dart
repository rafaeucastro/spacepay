class Validator {
  static String? Function(String?)? mandatoryFieldValidator = _mandatoryField;
  static String? Function(String?)? emailValidator = _email;
  static String? Function(String?)? alfaNumericValidator = _alfanumericPassword;
  static String? Function(String?)? cardNumber = _cardNumber;
  static String? Function(String?)? cardExpiryDate = _cardExpiryDate;
  static String? Function(String?)? cardCVC = _cardCVC;

  static String? _mandatoryField(String? userInput) {
    String email = userInput ?? "";
    if (email.isEmpty) {
      return "Campo obrigatório!";
    }
    return null;
  }

  static String? _email(String? userInput) {
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

  static String? _sixDigitCode(String? userInput) {
    final code = userInput ?? "";
    final digitPattern = RegExp('^\\d\\d\\d\\d\\d\\d\$');
    if (code.isEmpty) {
      return "Considere digitar o código!";
    } else if (!digitPattern.hasMatch(code)) {
      return "Somente números";
    }
    return null;
  }

  static String? _newPassword(String? userInput) {
    final password = userInput ?? "";
    if (password.isEmpty) {
      return "Considere digitar algo!";
    }
    return null;
  }

  static String? _alfanumericPassword(String? userInput) {
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

  static String? _cardNumber(String? userInput) {
    final cardNumber = userInput ?? "";
    if (cardNumber.isEmpty) {
      return "Considere digitar algo!";
    } else if (cardNumber.length != 19) {
      return "Digite o número completo!";
    }
    return null;
  }

  static String? _cardExpiryDate(String? userInput) {
    final expiryDate = userInput ?? "";

    int month = int.tryParse(expiryDate.substring(0, 2)) ?? 0;
    int year = int.tryParse(expiryDate.substring(3, 5)) ?? 0;
    int now = int.parse(DateTime.now().year.toString().substring(2, 4));
    int sixYearsFromNow = int.parse(
      DateTime.now()
          //somar 6 anos
          .add(const Duration(days: 30 * 12 * 6))
          .year
          .toString()
          //pegar apenas os dois últimos dígitos. ex: 2022 -> 22
          .substring(2, 4),
    );

    if (expiryDate.isEmpty) {
      return "Considere digitar algo!";
    } else if (expiryDate.length != 5) {
      return "Digite o número completo!";
    } else if (month < 1 || month > 12) {
      return "Mês inválido";
    } else if (year < now || year > sixYearsFromNow) {
      return "Ano inválido";
    }
    return null;
  }

  static String? _cardCVC(String? userInput) {
    final cvc = userInput ?? "";
    if (cvc.isEmpty) {
      return "Considere digitar algo!";
    } else if (cvc.length != 3) {
      return "Digite o número completo!";
    }
    return null;
  }
}
