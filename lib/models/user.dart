import 'dart:io';

abstract class MyUser {
  late final String id;
  late final String cpf;
  late final String fullName;
  late final String email;
  String address = '';
  String password = '';
  File? profilePicture;

  bool get hasProfilePicture {
    return profilePicture != null;
  }

  void setProfilePicture(File newProfilePicture) {
    profilePicture = newProfilePicture;
  }

  static String removeCaracteres(String cpf) {
    return cpf.replaceAll(RegExp('[/.-]'), '');
  }

  String get cpfNotFormatted {
    return removeCaracteres(cpf);
  }
}

class Client extends MyUser {
  final String accountType;
  int phone;

  Client({
    required this.accountType,
    required this.phone,
    required String cpf,
    required String fullName,
    required String address,
    required String password,
    required final String email,
    required final String id,
    File? profilePicture,
  }) {
    super.cpf = cpf;
    super.fullName = fullName;
    super.address = address;
    super.password = password;
    super.email = email;
    super.id = id;
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
        id: '',
      );
}

class Admin extends MyUser {
  String state;

  Admin({
    required this.state,
    required String cpf,
    required String fullName,
    required String address,
    required String password,
    required String id,
    String email = 'admin@admin.com',
  }) {
    super.cpf = cpf;
    super.fullName = fullName;
    super.address = address;
    super.password = password;
    super.id = id;
    super.email = email;
  }
}
