import 'dart:convert';

import 'package:banksys/models/constants.dart';
import 'package:banksys/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth.dart';
import 'card.dart';
import 'cards.dart';

class NewCardRequest {
  String cardType;
  String name;
  String id;
  String userID;
  String validity;

  NewCardRequest({
    required this.id,
    required this.userID,
    required this.cardType,
    required this.name,
    required this.validity,
  });
}

class BankCardRequests with ChangeNotifier {
  List<NewCardRequest> _newCardRequests = [];
  List<BankCard> _registeredCardRequests = [];

  List<NewCardRequest> get newCardRequests => [..._newCardRequests];
  List<BankCard> get registeredCardsRequests => [..._registeredCardRequests];

  Future<void> loadRequests(BuildContext context) async {
    _newCardRequests.clear();
    _registeredCardRequests.clear();

    final id = Provider.of<Auth>(context, listen: false).admin?.databaseID;

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/admins/$id/requests/createdCards.json"),
    );

    if (response.body != 'null') {
      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((requestID, request) {
        final newRequest = NewCardRequest(
          id: request['id'],
          cardType: request['cardType'],
          name: request['fullName'],
          validity: request['validity'],
          userID: request['userID'],
        );

        _newCardRequests.add(newRequest);
      });
    }

    final response2 = await http.get(
      Uri.parse(
          "${Constants.baseUrl}/admins/$id/requests/registeredCards.json"),
    );

    if (response2.body == 'null') return;

    final Map<String, dynamic> data2 = jsonDecode(response2.body);

    data2.forEach((cvc, request) {
      final cardRequest = BankCard(
        cardholderName: request[CardAttributes.cardholderName],
        expiryDate: request[CardAttributes.expiryDate],
        flag: request[CardAttributes.flag],
        number: request[CardAttributes.number],
        cvc: request[CardAttributes.cvc],
        databaseID: request[CardAttributes.databaseID],
      );

      _registeredCardRequests.add(cardRequest);
    });

    notifyListeners();
  }

  void confirmNewCardRequest(NewCardRequest newRequest, BuildContext context) {
    //TODO: Implementar melhor a solicitação de novo cartão
    final cards = Provider.of<Cards>(context, listen: false);
    final adminID = Provider.of<Auth>(context, listen: false).userId;

    //TODO: verificar se deu erro na solicitação http
    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/admins/$adminID/requests/createdCards/${newRequest.id}.json"),
    )
        .then((value) {
      _newCardRequests.remove(newRequest);
      cards.createNewCard(newRequest.name, newRequest.cardType,
          newRequest.validity, newRequest.userID, context);

      notifyListeners();
    });
  }

  void confirmRegisteredCardRequest(BankCard bankCard, BuildContext context) {
    //TODO: Implementar melhor a solicitação de novo cartão
    final cards = Provider.of<Cards>(context, listen: false);
    final adminID = Provider.of<Auth>(context, listen: false).userId;

    //TODO: verificar se deu erro na solicitação http
    http
        .delete(
      Uri.parse(
          "${Constants.baseUrl}/admins/$adminID/requests/registeredCards/${bankCard.cvc}.json"),
    )
        .then((value) {
      _registeredCardRequests.remove(bankCard);
      notifyListeners();
    });

    final response = http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/${bankCard.databaseID}/${UserAttributes.registeredCards}/${bankCard.cvc}.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: bankCard.cardholderName,
        CardAttributes.number: bankCard.number,
        CardAttributes.expiryDate: bankCard.expiryDate,
        CardAttributes.cvc: bankCard.cvc,
        CardAttributes.flag: bankCard.flag,
        CardAttributes.status: "Aprovado",
      }),
    );

    notifyListeners();
  }
}
