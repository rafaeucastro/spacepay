import 'package:banksys/models/user.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class Users with ChangeNotifier {
  final _keys = AttributesKeys();
  List<Client> _clientList = [];
  List<Admin> _adminList = [];

  List<Client> get clients => [..._clientList];
  List<Admin> get admins => [..._adminList];

  void addClient({required Map<String, String> clientData}) async {
    String phone = UtilBrasilFields.removeCaracteres(clientData[_keys.phone]!);
    String cpf = UtilBrasilFields.removeCaracteres(clientData[_keys.cpf]!);
    String email = clientData[_keys.email]!;
    String password = clientData[_keys.password]!;

    final newClient = Client(
      email: email,
      password: password,
      accountType: clientData[_keys.accountType]!,
      fullname: clientData[_keys.fullName]!,
      address: clientData[_keys.address]!,
      cpf: int.tryParse(cpf)!,
      phone: int.tryParse(phone)!,
    );

    _clientList.add(newClient);
    await Auth.signUp(email, password);
  }

  Future<void> addAdmin({required Map<String, String> clientData}) async {
    String cpf = UtilBrasilFields.removeCaracteres(clientData[_keys.cpf]!);

    final newAdmin = Admin(
      state: clientData[_keys.state]!,
      fullname: clientData[_keys.fullName]!,
      address: clientData[_keys.address]!,
      password: clientData[_keys.password]!,
      cpf: int.tryParse(cpf)!,
    );

    _adminList.add(newAdmin);
  }
}
