abstract class AccountType {
  static const savings = "Poupança";
  static const checking = "Corrente";
  static const List<String> accountTypes = ["Poupança", "Corrente"];
}

abstract class UserAttributes {
  static const fullName = "fullName";
  static const email = "email";
  static const cpf = "cpf";
  static const phone = "phone";
  static const address = "address";
  static const password = "password";
  static const accountType = "accountType";
  static const state = "state";
  static const databaseID = "databaseID";
}

abstract class User {
  final String? databaseID;
  final String cpf;
  final String fullName;
  String address;
  String password;

  User({
    required this.cpf,
    required this.fullName,
    required this.address,
    required this.password,
    this.databaseID,
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
    required String cpf,
    required String fullname,
    required String address,
    required String password,
    final String? databaseID,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          address: address,
          password: password,
          databaseID: databaseID,
        );
}

class Admin extends User {
  String state;

  Admin({
    required this.state,
    required String cpf,
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
