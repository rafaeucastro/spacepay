import 'dart:async';
import 'dart:convert';

import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/models/exceptions/user_not_found_expection.dart';
import 'package:spacepay/util/constants.dart';
import 'package:spacepay/models/user.dart';
import 'package:spacepay/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class AuthMode {
  static const signIn = "signIn";
  static const signUp = "signUp";
}

class Auth extends Constants with ChangeNotifier {
  static const email = "email";
  static const password = "password";
  bool _isADM = false;
  Admin? _admin;
  Client _client = Client.defaulUser;
  String? _token;
  String? _userId;

  Client get client {
    return _client;
  }

  Admin? get admin {
    if (isAdminAuthenticated) {
      return _admin;
    }
    return null;
  }

  bool get isADM {
    return _isADM;
  }

  bool get isAdminAuthenticated {
    return _userId != null && isADM;
  }

  bool get isClientAuth {
    return _token != null && _userId != null && !_isADM;
  }

  String? get token {
    return isClientAuth ? _token : null;
  }

  String? get userId {
    return isClientAuth || isAdminAuthenticated ? _userId : null;
  }

  //TODO: FAZER USUÁRIO PERMANECER LOGADO AO FECHAR O APP SEM FAZER LOGOUT
  void logout() {
    _isADM = false;
    _client = Client.defaulUser;
    _admin = null;
    _token = null;
    _userId = null;

    notifyListeners();
  }

  static Future<void> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse(Constants.signUpUrl),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.body.isEmpty) {
      throw AuthException("Erro");
    }
  }

  Future<void> logIn(String cpf, String password, bool isADM) async {
    Admin? admin;
    _isADM = isADM;

    if (isADM) {
      try {
        admin = Users.admins.firstWhere((adm) => adm.cpf == cpf);
      } on Exception {
        UserNotFoundException('ERRO');
        return;
      } catch (error) {
        throw UserNotFoundException(error.toString());
      }

      admin.password == password
          ? _userId = admin.databaseID
          : throw AuthException('INVALID_PASSWORD');
      _admin = admin;
    }

    if (!isADM) {
      try {
        _client = Users.clients.firstWhere((client) => client.cpf == cpf);
      } on Exception {
        return;
      } catch (error) {
        throw UserNotFoundException(error.toString());
      }

      final response = await http.post(
        Uri.parse(Constants.signInUrl),
        body: jsonEncode({
          'email': client.email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final body = jsonDecode(response.body);

      if (body['error'] != null) {
        throw AuthException(body['error']['errors'][0]['message']);
      } else {
        //_email = body['email'];
        _userId = body['localId'];
        _token = body['idToken'];
      }
    }

    notifyListeners();
  }
}
