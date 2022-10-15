import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'auth.dart';

import 'package:spacepay/models/constants.dart';
import 'package:spacepay/models/user.dart';

class Users with ChangeNotifier {
  static late final List<Client> clients;
  static late final List<Admin> admins;
  // ignore: prefer_final_fields
  List<Client> _clientList = [];
  // ignore: prefer_final_fields
  List<Admin> _adminList = [];
  final Client? _loggedClient;

  Users(this._loggedClient, this._clientList);

  List<Client> get getClients => [..._clientList];
  // List<Admin> get admins => [..._adminList];

  Future<void> loadData() async {
    _clientList.clear();
    late final http.Response response;
    late final http.Response responseAdm;

    //TODO: lidar com as exceções. ex: caso o usuário não tenha net
    try {
      response = await http.get(Uri.parse(Constants.clientsUrl));
    } on http.ClientException {
      return;
    } catch (error) {
      return;
    }

    try {
      responseAdm = await http.get(Uri.parse(Constants.adminsUrl));
    } on http.ClientException {
      return;
    } catch (error) {
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final Map<String, dynamic> dataAdm = jsonDecode(responseAdm.body) ?? {};

    data.forEach((userID, userData) {
      final newClient = Client(
        email: userData[UserAttributes.email].toString(),
        accountType: userData[UserAttributes.accountType].toString(),
        fullname: userData[UserAttributes.fullName].toString(),
        address: userData[UserAttributes.address].toString(),
        password: userData[UserAttributes.password].toString(),
        phone: int.parse(userData[UserAttributes.phone] ?? '0'),
        cpf: userData[UserAttributes.cpf].toString(),
        databaseID: userID,
        profilePicture: File(userData['profilePicture'] ?? ""),
      );
      _clientList.add(newClient);
    });

    dataAdm.forEach((userID, admData) {
      _adminList.add(Admin(
        state: admData[UserAttributes.state],
        cpf: admData[UserAttributes.cpf],
        fullname: admData[UserAttributes.fullName],
        address: admData[UserAttributes.address],
        password: admData[UserAttributes.password],
        databaseID: userID,
      ));
    });

    clients = _clientList;
    admins = _adminList;
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

  Future<File?> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    );

    if (imageFile == null) return null;

    File storedImage;

    storedImage = File(imageFile.path);

    //get app directory
    final appDir = await getApplicationDocumentsDirectory();
    //get only the file's name
    final String fileExtension = path.extension(storedImage.path);

    return storedImage.copy('${appDir.path}/profilePicture$fileExtension');
  }

  Future<File?> setUserProfilePicture() async {
    final profilePicture = await _takePicture();

    //if the user don't take the picture
    if (profilePicture == null) return null;

    final user =
        _clientList.firstWhere((element) => _loggedClient!.cpf == element.cpf);

    //define the picture for the current user
    if (user.profilePicture != null) {
      await user.profilePicture!.exists()
          ? user.profilePicture!.delete()
          : null;
    }
    user.profilePicture = profilePicture;

    //TODO: tratar a resposta
    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/clients/${user.databaseID}.json'),
      body: jsonEncode({
        'profilePicture': profilePicture.path,
      }),
    );

    // print(response.statusCode);
    // print(response.body);

    return profilePicture;
  }

  Future<File?> loadProfilePicture() async {
    final fileExists = await _loggedClient!.profilePicture!.exists();
    if (!fileExists) return null;

    return File(_loggedClient!.profilePicture!.path);
  }
}
