import 'dart:io';

import 'package:spacepay/models/card.dart';
import 'card_request.dart';

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
  static const myCards = "myCards";
  static const cardRequests = "cardRequests";
}

abstract class User {
  final String? databaseID;
  final String cpf;
  final String fullName;
  String address;
  String password;
  File? profilePicture;

  User({
    required this.cpf,
    required this.fullName,
    required this.address,
    required this.password,
    this.databaseID,
    this.profilePicture,
  });

  bool get hasProfilePicture {
    return profilePicture != null;
  }

  void setProfilePicture(File newProfilePicture) {
    profilePicture = newProfilePicture;
  }
}

class Client extends User {
  final String email;
  final String accountType;
  int phone;
  // ignore: prefer_final_fields
  List<BankCard> _myCards = [];
  // ignore: prefer_final_fields
  List<CardRequest> _cardRequests = [];

  List<BankCard> get myCards => [..._myCards];
  List<CardRequest> get cardRequests => [..._cardRequests];

  Client({
    required this.email,
    required this.accountType,
    required this.phone,
    required String cpf,
    required String fullname,
    required String address,
    required String password,
    final String? databaseID,
    File? profilePicture,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          address: address,
          password: password,
          databaseID: databaseID,
          profilePicture: profilePicture,
        );

  void addCard(BankCard card) {
    _myCards.add(card);
  }

  void addCardRequest(CardRequest card) {
    _cardRequests.add(card);
  }

  void removeCard(BankCard card) {
    _myCards.remove(card);
  }

  void removeRequest(CardRequest request) {
    _cardRequests.remove(request);
  }

  void clearMyCards() {
    _myCards.clear();
  }

  void clearCardRequests() {
    _cardRequests.clear();
  }

  static Client get defaulUser => Client(
        email: "default@email.com",
        accountType: 'Checking A',
        phone: 0000000,
        cpf: '999.999.999-99',
        fullname: 'Default User',
        address: 'Street A',
        password: 'default',
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
    final String? databaseID,
  }) : super(
          cpf: cpf,
          fullName: fullname,
          address: address,
          password: password,
          databaseID: databaseID,
        );
}
