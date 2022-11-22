import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:spacepay/models/auth_service.dart';
import 'package:spacepay/models/exceptions/auth_exception.dart';

import 'package:spacepay/util/constants.dart';
import 'package:spacepay/models/user.dart';

class Users with ChangeNotifier {
  //static late final List<Client> clients;
  //static late final List<Admin> admins;

  final List<Admin> _adminList = [];
  final List<Client> _clientList = [];

  List<Client> get getClients => [..._clientList];
  List<Admin> get admins => [..._adminList];

  Future<void> loadAdmins() async {
    _adminList.clear();

    late final http.Response responseAdm;

    try {
      responseAdm = await http.get(Uri.parse(Constants.adminsUrl));
    } on http.ClientException {
      return;
    } catch (error) {
      return;
    }
    final Map<String, dynamic> dataAdm = jsonDecode(responseAdm.body) ?? {};

    dataAdm.forEach((databaseID, admData) {
      _adminList.add(Admin(
        state: admData[UserAttributes.state],
        cpf: admData[UserAttributes.cpf],
        fullName: admData[UserAttributes.fullName],
        address: admData[UserAttributes.address],
        password: admData[UserAttributes.password],
        id: admData[UserAttributes.id],
      ));
    });

    //admins = _adminList;

    notifyListeners();
  }

  Future<void> loadClients() async {
    _clientList.clear();
    late final http.Response response;

    //TODO: lidar com as exceções. ex: caso o usuário não tenha net
    try {
      response = await http.get(Uri.parse(Constants.clientsUrl));
    } on http.ClientException {
      return;
    } catch (error) {
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((databaseID, userData) {
      final newClient = Client(
        email: userData[UserAttributes.email],
        accountType: userData[UserAttributes.accountType],
        fullName: userData[UserAttributes.fullName],
        address: userData[UserAttributes.address],
        password: userData[UserAttributes.password],
        phone: userData[UserAttributes.phone],
        cpf: userData[UserAttributes.cpf],
        id: userData[UserAttributes.id],
      );

      _clientList.add(newClient);
    });

    //clients = _clientList;

    notifyListeners();
  }

  static Future<Client> getClientFromDB(String cpf) async {
    String databaseID = MyUser.removeCaracteres(cpf);

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/clients/$databaseID.json'),
    );

    if (response.body == 'null') throw AuthException('NO_ELEMENT');

    final Map<String, dynamic> userData = jsonDecode(response.body);

    final client = Client(
      email: userData[UserAttributes.email],
      accountType: userData[UserAttributes.accountType],
      fullName: userData[UserAttributes.fullName],
      address: userData[UserAttributes.address],
      password: userData[UserAttributes.password],
      phone: userData[UserAttributes.phone],
      cpf: userData[UserAttributes.cpf],
      id: userData[UserAttributes.id],
    );

    return client;
  }

  static Future<Admin> getAdmFromDB(String cpf) async {
    String databaseID = MyUser.removeCaracteres(cpf);

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/admins/$databaseID.json'),
    );

    if (response.body == 'null') throw AuthException('NO_ELEMENT');

    final Map<String, dynamic> userData = jsonDecode(response.body);

    final admin = Admin(
      state: userData[UserAttributes.state],
      email: userData[UserAttributes.email],
      fullName: userData[UserAttributes.fullName],
      address: userData[UserAttributes.address],
      password: userData[UserAttributes.password],
      cpf: userData[UserAttributes.cpf],
      id: userData[UserAttributes.id],
    );

    return admin;
  }

  void saveClientInDatabase(Client client) async {
    //TODO: Tratar resposta
    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/clients/${client.cpfNotFormatted}.json'),
      body: jsonEncode({
        UserAttributes.phone: client.phone,
        UserAttributes.cpf: client.cpf,
        UserAttributes.email: client.email,
        UserAttributes.password: client.password,
        UserAttributes.accountType: client.accountType,
        UserAttributes.fullName: client.fullName,
        UserAttributes.address: client.address,
        UserAttributes.id: client.id,
      }),
    );
  }

  Future<void> signUp({required Map<String, String> clientData}) async {
    String phone = clientData[UserAttributes.phone]!;
    String cpf = clientData[UserAttributes.cpf]!;
    String email = clientData[UserAttributes.email]!;
    String password = clientData[UserAttributes.password]!;
    String accountType = clientData[UserAttributes.accountType]!;
    String fullName = clientData[UserAttributes.fullName]!;
    String address = clientData[UserAttributes.address]!;

    String userID = '';

    try {
      userID = await AuthFirebaseService().signUp(fullName, email, password);
    } on FirebaseAuthException catch (error) {
      throw AuthException(error.code);
    }

    if (userID.isEmpty) throw AuthException('');

    final newClient = Client(
      email: email,
      password: password,
      accountType: accountType,
      fullName: fullName,
      address: address,
      cpf: cpf,
      phone: phone,
      id: userID,
    );

    saveClientInDatabase(newClient);

    _clientList.add(newClient);

    //fazer login
    await AuthFirebaseService().signIn(cpf, password, false);
  }

  //TODO: verificar adição de ADM
  Future<void> addAdmin({required Map<String, String> userData}) async {
    String fullName = userData[UserAttributes.fullName]!;
    String email = userData[UserAttributes.email]!;
    String password = userData[UserAttributes.password]!;
    String cpf = userData[UserAttributes.cpf]!;

    final userID = await AuthFirebaseService()
        .signUp(userData[UserAttributes.fullName]!, email, password);

    if (userID.isEmpty) throw AuthException('');

    String databaseID = MyUser.removeCaracteres(cpf);

    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/admins/$databaseID.json'),
      body: jsonEncode({
        UserAttributes.cpf: '00000000000',
        UserAttributes.fullName: fullName,
        UserAttributes.email: userData[UserAttributes.email]!,
        UserAttributes.password: password,
        UserAttributes.address: userData[UserAttributes.address]!,
        UserAttributes.state: userData[UserAttributes.state] ?? 'Ceará',
        UserAttributes.id: userID,
      }),
    );

    final newAdmin = Admin(
      cpf: userData[UserAttributes.cpf]!,
      fullName: userData[UserAttributes.fullName]!,
      email: userData[UserAttributes.email]!,
      password: userData[UserAttributes.password]!,
      address: userData[UserAttributes.address]!,
      state: userData[UserAttributes.state] ?? 'Ceará',
      id: userID,
    );

    _adminList.add(newAdmin);
  }

  Future<File?> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (imageFile == null) return null;

    return File(imageFile.path);
  }

  Future<File?> setUserProfilePicture() async {
    final storedImage = await _takePicture();

    //if the user don't take the picture
    if (storedImage == null) return null;

    //get only the file's name
    final String fileExtension = path.extension(storedImage.path);
    final appDir = await getApplicationDocumentsDirectory();

    //save the picture locally
    final newProfilePicture = await storedImage.copy(
        '${appDir.path}/profile_picture-${AuthFirebaseService().currentClient!.cpf}$fileExtension');

    AuthFirebaseService().currentClient!.setProfilePicture(storedImage);

    notifyListeners();
    return newProfilePicture;
  }

  Future<File?> loadProfilePicture() async {
    final appDir = await getApplicationDocumentsDirectory();

    final profilePicture = File(
        '${appDir.path}/profile_picture-${AuthFirebaseService().currentClient!.cpf}.jpg');

    if (await profilePicture.exists()) {
      AuthFirebaseService().currentClient!.profilePicture = profilePicture;
      return profilePicture;
    }

    return null;
  }
}
