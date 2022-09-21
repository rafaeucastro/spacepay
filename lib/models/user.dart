abstract class AccountType {
  static const savings = "Poupança";
  static const checking = "Corrente";
}

abstract class User {
  final int cpf;
  final String fullName;
  String adress;
  String password;

  User({
    required this.cpf,
    required this.fullName,
    required this.adress,
    required this.password,
  });
}

class Client extends User {
  final String email;
  final AccountType accountType;
  int phone;

  Client({
    required this.email,
    required this.accountType,
    required this.phone,
    required int cpf,
    required String fullname,
    required String adress,
    required String password,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          adress: adress,
          password: password,
        );
}

class Admin extends User {
  String state;

  Admin({
    required this.state,
    required int cpf,
    required String fullname,
    required String adress,
    required String password,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          adress: adress,
          password: password,
        );
}
