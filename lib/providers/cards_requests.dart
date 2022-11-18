// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:spacepay/models/auth_service.dart';
import 'package:spacepay/models/user.dart';
import 'package:spacepay/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/card.dart';
import '../models/card_request.dart';
import 'cards.dart';

class BankCardRequests with ChangeNotifier {
  List<CardRequest> _cardRequests = [];

  List<CardRequest> get cardRequests => [..._cardRequests];

  Future<void> loadRequests(BuildContext context) async {
    _cardRequests.clear();

    final cpf = AuthFirebaseService().currentADM!.cpf;

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/admins/$cpf/cardRequests.json"),
    );

    if (response.body != 'null') {
      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((requestID, request) {
        final newRequest = CardRequest(
          id: request['id'],
          cardType: request['cardType'],
          name: request['fullName'],
          validity: request['validity'],
          cpf: request['cpf'],
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

    final databaseID = MyUser.removeCaracteres(newRequest.cpf);
    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/clients/$databaseID/analisys/${newRequest.id}.json"),
    )
        .then((value) {
      notifyListeners();
    });

    //TODO: verificar se deu erro na solicitação http
    final cpf = AuthFirebaseService().currentADM!.cpfNotFormatted;
    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/admins/$cpf/cardRequests/${newRequest.id}.json"),
    )
        .then((value) {
      _cardRequests.remove(newRequest);
      cards.createNewCard(newRequest);

      notifyListeners();
    });
  }

  //TODO: REFATORAR
  void refuseCardRequest(String reason, CardRequest request) {
    final cpf = AuthFirebaseService().currentADM!.cpfNotFormatted;

    //apagar o cartão no banco de dados do admin
    http.delete(Uri.parse(
        "${Constants.baseUrl}/admins/$cpf/cardRequests/${request.id}.json"));

    _cardRequests.remove(request);

    final databaseID = MyUser.removeCaracteres(request.cpf);

    //atualizar o status do cartão no banco de dados do cliente
    http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$databaseID/cards/analisys/${request.id}.json"),
      body: jsonEncode({
        CardAttributes.status: "Negado",
        'refusalReason': reason,
      }),
    );

    notifyListeners();
  }
}
