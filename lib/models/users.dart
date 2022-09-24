import 'dart:convert';

import 'package:banksys/models/constants.dart';
import 'package:banksys/models/user.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';

class Users with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Client> _clientList = [];
  static late final List<Client> clients;
  // ignore: prefer_final_fields
  List<Admin> _adminList = [];

  // List<Client> get clients => [..._clientList];
  // List<Admin> get admins => [..._adminList];

  Future<void> loadData() async {
    _clientList.clear();
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/clients.json'));

    final Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((userID, userData) {
      _clientList.add(
        Client(
          email: userData[UserAttributes.email],
          accountType: userData[UserAttributes.accountType],
          fullname: userData[UserAttributes.fullName],
          address: userData[UserAttributes.address],
          password: userData[UserAttributes.password],
          phone: int.parse(userData[UserAttributes.phone]),
          cpf: userData[UserAttributes.cpf],
          databaseID: userData[UserAttributes.databaseID],
        ),
      );
    });

    clients = _clientList;
  }

  void addClient({required Map<String, String> clientData}) async {
    String phone =
        UtilBrasilFields.removeCaracteres(clientData[UserAttributes.phone]!);
    String cpf = clientData[UserAttributes.cpf]!;
    String email = clientData[UserAttributes.email]!;
    String password = clientData[UserAttributes.password]!;
    String accountType = clientData[UserAttributes.accountType]!;
    String fullname = clientData[UserAttributes.fullName]!;
    String address = clientData[UserAttributes.address]!;

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/clients.json'),
      body: jsonEncode({
        UserAttributes.phone: phone,
        UserAttributes.cpf: cpf,
        UserAttributes.email: email,
        UserAttributes.password: password,
        UserAttributes.accountType: accountType,
        UserAttributes.fullName: fullname,
        UserAttributes.address: address,
      }),
    );

    final id = jsonDecode(response.body)['name'].toString();

    final newClient = Client(
      email: email,
      password: password,
      accountType: accountType,
      fullname: fullname,
      address: address,
      cpf: cpf,
      phone: int.parse(phone),
      databaseID: id,
    );

    _clientList.add(newClient);
    //TOOD: verificar se deu certo se inscrever
    await Auth.signUp(email, password);
  }

  Future<void> addAdmin({required Map<String, String> clientData}) async {
    String cpf = clientData[UserAttributes.cpf]!;

    final newAdmin = Admin(
      state: clientData[UserAttributes.state]!,
      fullname: clientData[UserAttributes.fullName]!,
      address: clientData[UserAttributes.address]!,
      password: clientData[UserAttributes.password]!,
      cpf: cpf,
    );

    _adminList.add(newAdmin);
  }
}
