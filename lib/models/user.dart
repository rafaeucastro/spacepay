import 'package:spacepay/models/card.dart';

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
  static const createdCards = "createdCards";
  static const registeredCards = "registeredCards";
  static const cardRequests = "cardRequests";
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
  // ignore: prefer_final_fields
  List<BankCard> _createdCards = [];
  // ignore: prefer_final_fields
  List<BankCard> _existingCards = [];

  List<BankCard> get createdCards => [..._createdCards];
  List<BankCard> get existingCards => [..._existingCards];

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

  void addCreatedCard(BankCard card) {
    _createdCards.add(card);
  }

  void addExistingCard(BankCard card) {
    _existingCards.add(card);
  }
}

class Admin extends User {
  String state;

  Admin({
    required this.state,
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
