import 'dart:async';
import 'dart:convert';

import 'package:banksys/exceptions/auth_exception.dart';
import 'package:banksys/exceptions/user_not_found_expection.dart';
import 'package:banksys/models/constants.dart';
import 'package:banksys/models/user.dart';
import 'package:banksys/models/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class AuthMode {
  static const signIn = "signIn";
  static const signUp = "signUp";
}

class Auth with ChangeNotifier {
  static const email = "email";
  static const password = "password";
  bool? _isADM = false;
  Client? _client;
  Admin? _admin;
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  // Timer? _logoutTimer;

  Client? get client {
    if (isClientAuth) {
      return _client;
    }
    return null;
  }

  Admin? get admin {
    if (isAdminAuthenticated) {
      return _admin;
    }
    return null;
  }

  bool get isADM {
    return _isADM ?? false;
  }

  bool get isAdminAuthenticated {
    return _userId != null && isADM;
  }

  bool get isClientAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid && !_isADM!;
  }

  String? get token {
    return isClientAuth ? _token : null;
  }

  String? get eMail {
    return isClientAuth ? _email : null;
  }

  String? get userId {
    return isClientAuth || isAdminAuthenticated ? _userId : null;
  }

  void logout() {
    _isADM = false;
    _client = null;
    _admin = null;
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

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
    //TODO: verificar a resposta
    if (response.body.isEmpty) {
      return;
    }
  }

  Future<void> authenticate(String cpf, String password, bool isADM) async {
    Client? client;
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
    } else {
      try {
        client = Users.clients.firstWhere((client) => client.cpf == cpf);
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
        _email = body['email'];
        _userId = body['localId'];
        _token = body['idToken'];
        _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(body['expiresIn'])),
        );
      }

      _client = client;
    }

    notifyListeners();
  }
}
