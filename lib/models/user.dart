import 'dart:io';

abstract class User {
  late final String databaseID;
  late final String cpf;
  late final String fullName;
  String address = '';
  String password = '';
  File? profilePicture;

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

  Client({
    required this.email,
    required this.accountType,
    required this.phone,
    required String cpf,
    required String fullName,
    required String address,
    required String password,
    required final String databaseID,
    File? profilePicture,
  }) {
    super.cpf = cpf;
    super.fullName = fullName;
    super.address = address;
    super.password = password;
    super.databaseID = databaseID;
    super.profilePicture = profilePicture;
  }

  static Client get defaulUser => Client(
        email: "default@email.com",
        accountType: 'Checking A',
        phone: 0000000,
        cpf: '999.999.999-99',
        fullName: 'Default User',
        address: 'Street A',
        password: 'default',
        databaseID: '',
      );
}

class Admin extends User {
  String state;

  Admin({
    required this.state,
    required String cpf,
    required String fullName,
    required String address,
    required String password,
    required final String databaseID,
  }) {
    super.cpf = cpf;
    super.fullName = fullName;
    super.address = address;
    super.password = password;
    super.databaseID = databaseID;
  }
}
