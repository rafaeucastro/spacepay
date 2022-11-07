// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:math';

import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/util/constants.dart';
import 'package:spacepay/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/card_request.dart';

class Cards with ChangeNotifier {
  List<String> _allCardNumbers = [];
  List<int> _allCVCs = [];

  void addCard(Map<String, String> formData, BuildContext context) async {
    final number = formData[CardAttributes.number]!;
    final cvc = int.parse(formData[CardAttributes.cvc]!);
    final cardholderName = formData[CardAttributes.cardholderName]!;
    final expiryDate = formData[CardAttributes.expiryDate]!;
    final flag = formData[CardAttributes.flag]!;

    final client = Provider.of<Auth>(context, listen: false).client;
    final clientDatabaseID =
        Provider.of<Auth>(context, listen: false).client.databaseID;
    if (clientDatabaseID == null) return;

    await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$clientDatabaseID/cards/myCards/$cvc.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: cardholderName,
        CardAttributes.number: number,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
        CardAttributes.flag: flag,
        CardAttributes.databaseID: clientDatabaseID,
      }),
    );

    final newCard = BankCard(
      cardholderName: cardholderName,
      expiryDate: expiryDate,
      flag: flag,
      number: number,
      cvc: cvc,
      databaseID: clientDatabaseID,
    );

    client.addCard(newCard);
    notifyListeners();
  }

  void sendCardForAnalysis(String name, String cardType, String validity,
      BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;
    final clientDatabaseID =
        Provider.of<Auth>(context, listen: false).client.databaseID;

    final response = await http.post(
      Uri.parse(
          "${Constants.baseUrl}/admins/-NCl0gUqE_K4QWFn-Qyu/cardRequests.json"),
      body: jsonEncode({
        UserAttributes.fullName: name,
        'cardType': cardType,
        'validity': validity,
        'userID': clientDatabaseID,
      }),
    );

    if (response.body == 'null') return;

    final String id = jsonDecode(response.body)['name'];

    final response2 = await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/admins/-NCl0gUqE_K4QWFn-Qyu/cardRequests/$id/.json"),
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response2.body == 'null') return;

    await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$clientDatabaseID/cards/analisys/$id.json"),
      body: jsonEncode({
        UserAttributes.fullName: name,
        'cardType': cardType,
        'validity': validity,
        'userID': clientDatabaseID,
        'status': 'Em análise',
      }),
    );

    client.addCardRequest(CardRequest(
      id: id,
      userID: client.databaseID!,
      cardType: cardType,
      name: name,
      validity: validity,
      status: 'Em análise',
    ));

    notifyListeners();
  }

  //TODO: REFATORAR: MOVER PARA MODELS
  void createNewCard(CardRequest cardRequest, BuildContext context) async {
    final String flag = CardFlag.randomFlag;
    final String expiryDate = BankCard.getExpiryDate(cardRequest.validity);
    int cvc = Random().nextInt(899) + 100;
    String cardNumber = BankCard.generateRamdomCardNumber;

    bool isCardNumberExclusive = !_allCardNumbers.contains(cardNumber);
    bool isCVCExclusive = !_allCVCs.contains(cvc);

    while (!isCVCExclusive) {
      cvc = Random().nextInt(899) + 100;
      _allCVCs.contains(cvc) ? null : isCVCExclusive = true;
    }

    while (!isCardNumberExclusive) {
      cardNumber = BankCard.generateRamdomCardNumber;
      _allCardNumbers.contains(cardNumber)
          ? null
          : isCardNumberExclusive = true;
    }

    //TODO: verificar se deu certo inserir
    final response = await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/${cardRequest.userID}/cards/myCards/$cvc.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: cardRequest.name,
        CardAttributes.number: cardNumber,
        CardAttributes.flag: flag,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
      }),
    );

    notifyListeners();
  }

  Future<void> removeCard(BankCard card, BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;
    if (client == null) return;

    final response = await http.delete(
      Uri.parse(
          '${Constants.baseUrl}/clients/${client.databaseID}/cards/myCards/${card.cvc}.json'),
    );
    //TOOD: retornar true para verificar se foi possível remover do firebase ou não, caso o status code for diferente de 200
    if (response.statusCode == 200) {
      client.removeCard(card);
    }

    // print("id: ${card.databaseID}");
    // print("response: ${jsonDecode(response.statusCode.toString())}");

    notifyListeners();
  }

  void removeRefusedCardRequest(
      CardRequest request, BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;
    if (client == null) return;

    //apagar o cartão no banco de dados do cliente
    await http.delete(Uri.parse(
        "${Constants.baseUrl}/clients/${client.databaseID}/cards/analisys/${request.id}.json"));

    client.removeRequest(request);

    notifyListeners();
  }

  Future<void> loadMyCards(BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;
    if (client == null) return;

    client.clearMyCards();

    final response = await http.get(
      Uri.parse(
          "${Constants.baseUrl}/clients/${client.databaseID}/cards/myCards.json"),
    );

    //TODO: tratar quando vier nulo
    if (response.body != 'null') {
      Map<String, dynamic> myCardsData = jsonDecode(response.body);

      myCardsData.forEach((key, cards) {
        final card = BankCard(
          cardholderName: cards[CardAttributes.cardholderName],
          expiryDate: cards[CardAttributes.expiryDate],
          flag: cards[CardAttributes.flag],
          number: cards[CardAttributes.number],
          cvc: cards[CardAttributes.cvc],
          databaseID: key,
        );

        client.addCard(card);
        _allCardNumbers.add(cards[CardAttributes.number]);
      });
    }

    notifyListeners();
  }

  Future<void> loadCardRequests(BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;

    client.clearCardRequests();

    final response = await http.get(
      Uri.parse(
          "${Constants.baseUrl}/clients/${client.databaseID}/cards/analisys.json"),
    );

    if (response.body != 'null') {
      Map<String, dynamic> cardRequestsData = jsonDecode(response.body);

      cardRequestsData.forEach((key, request) {
        final newRequest = CardRequest(
          name: request['fullName'],
          id: key,
          userID: request['userID'],
          cardType: request['cardType'],
          status: request['status'],
          validity: request['validity'],
          refusalReason: request['refusalReason'],
        );

        client.addCardRequest(newRequest);
      });
    }

    notifyListeners();
  }
}
