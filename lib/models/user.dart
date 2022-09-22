abstract class AccountType {
  static const savings = "Poupança";
  static const checking = "Corrente";
  static const List<String> accountTypes = ["Poupança", "Corrente"];
}

class UserAttributes {
  final fullName = "fullName";
  final email = "email";
  final cpf = "cpf";
  final phone = "phone";
  final address = "address";
  final password = "password";
  final accountType = "accountType";
  final state = "state";
}

abstract class User {
  final int cpf;
  final String fullName;
  String address;
  String password;

  User({
    required this.cpf,
    required this.fullName,
    required this.address,
    required this.password,
  });
}

class Client extends User {
  final String email;
  final String accountType;
  int phone;

  Client({
    required this.email,
    required this.accountType,
    required this.phone,
    required int cpf,
    required String fullname,
    required String address,
    required String password,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          address: address,
          password: password,
        );
}

class Admin extends User {
  String state;

  Admin({
    required this.state,
    required int cpf,
    required String fullname,
    required String address,
    required String password,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          address: address,
          password: password,
        );
}
