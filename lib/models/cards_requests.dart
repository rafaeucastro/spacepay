import 'dart:convert';

import 'package:banksys/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth.dart';
import 'cards.dart';

class NewCardRequest {
  String cardType;
  String name;
  String? id;
  String? userID;
  String validity;

  NewCardRequest({
    this.id,
    this.userID,
    required this.cardType,
    required this.name,
    required this.validity,
  });
}

class BankCardRequests with ChangeNotifier {
  List<NewCardRequest> _requests = [];

  List<NewCardRequest> get requests => [..._requests];

  Future<void> loadRequests(BuildContext context) async {
    _requests.clear();

    final id = Provider.of<Auth>(context, listen: false).admin?.databaseID;

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/admins/$id/requests/createdCards.json"),
    );

    if (response.body == 'null') return;

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((requestID, request) {
      final newRequest = NewCardRequest(
        id: request['id'],
        cardType: request['cardType'],
        name: request['fullName'],
        validity: request['validity'],
      );

      _requests.add(newRequest);
    });

    notifyListeners();
  }

  Future<void> confirmRequest(
      NewCardRequest newRequest, BuildContext context) async {
    //TODO: Implementar melhor a solicitação de novo cartão
    final cards = Provider.of<Cards>(context, listen: false);
    final adminID = Provider.of<Auth>(context, listen: false).userId;

    final response = await http.delete(
      Uri.parse(
          "${Constants.baseUrl}/admins/$adminID/requests/createdCards/${newRequest.id}.json"),
    );

    _requests.remove(newRequest);

    notifyListeners();
  }
}
