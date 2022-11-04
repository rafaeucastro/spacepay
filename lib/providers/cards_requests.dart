// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:spacepay/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../models/card.dart';
import '../models/card_request.dart';
import 'cards.dart';

class BankCardRequests with ChangeNotifier {
  List<CardRequest> _cardRequests = [];

  List<CardRequest> get cardRequests => [..._cardRequests];

  Future<void> loadRequests(BuildContext context) async {
    _cardRequests.clear();

    final id = Provider.of<Auth>(context, listen: false).admin?.databaseID;

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/admins/$id/cardRequests.json"),
    );

    if (response.body != 'null') {
      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((requestID, request) {
        final newRequest = CardRequest(
          id: request['id'],
          cardType: request['cardType'],
          name: request['fullName'],
          validity: request['validity'],
          userID: request['userID'],
          status: request['status'] ?? '',
        );

        _cardRequests.add(newRequest);
      });
    }

    notifyListeners();
  }

  void confirmCardRequest(CardRequest newRequest, BuildContext context) {
    //TODO: Implementar melhor a solicitação de novo cartão
    final cards = Provider.of<Cards>(context, listen: false);
    final adminID = Provider.of<Auth>(context, listen: false).userId;

    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/clients/${newRequest.userID}/cards/analisys/${newRequest.id}.json"),
    )
        .then((value) {
      notifyListeners();
    });

    //TODO: verificar se deu erro na solicitação http
    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/admins/$adminID/cardRequests/${newRequest.id}.json"),
    )
        .then((value) {
      _cardRequests.remove(newRequest);
      cards.createNewCard(newRequest, context);

      notifyListeners();
    });
  }

  //TODO: REFATORAR
  void refuseCardRequest(
      String reason, CardRequest request, BuildContext context) {
    final adminID = Provider.of<Auth>(context, listen: false).userId;

    //apagar o cartão no banco de dados do admin
    http.delete(Uri.parse(
        "${Constants.baseUrl}/admins/$adminID/cardRequests/${request.id}.json"));

    _cardRequests.remove(request);

    //atualizar o status do cartão no banco de dados do cliente
    http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/${request.userID}/cards/analisys/${request.id}.json"),
      body: jsonEncode({
        CardAttributes.status: "Negado",
        'refusalReason': reason,
      }),
    );

    notifyListeners();
  }
}
