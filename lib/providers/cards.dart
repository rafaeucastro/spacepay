// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:math';

import 'package:spacepay/models/auth_service.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/models/user.dart';
import 'package:spacepay/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/card_request.dart';

class Cards with ChangeNotifier {
  List<String> _allCardNumbers = [];
  List<int> _allCVCs = [];
  List<BankCard> _myCards = [];
  List<CardRequest> _myRequests = [];

  List<BankCard> get myCards => [..._myCards];
  List<CardRequest> get myRequests => [..._myRequests];

  void addCard(Map<String, String> formData) async {
    final number = formData[CardAttributes.number]!;
    final cvc = int.parse(formData[CardAttributes.cvc]!);
    final cardholderName = formData[CardAttributes.cardholderName]!;
    final expiryDate = formData[CardAttributes.expiryDate]!;
    final flag = formData[CardAttributes.flag]!;

    final databaseID =
        MyUser.removeCaracteres(AuthFirebaseService().currentClient!.cpf);

    await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$databaseID/cards/myCards/$cvc.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: cardholderName,
        CardAttributes.number: number,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
        CardAttributes.flag: flag,
      }),
    );

    final newCard = BankCard(
      cardholderName: cardholderName,
      expiryDate: expiryDate,
      flag: flag,
      number: number,
      cvc: cvc,
    );

    //client.addCard(newCard);
    _myCards.add(newCard);

    notifyListeners();
  }

  void sendCardForAnalysis(
    String name,
    String cardType,
    String validity,
  ) async {
    final cpf = AuthFirebaseService().currentClient!.cpf;

    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/admins/00000000000/cardRequests.json"),
      body: jsonEncode({
        UserAttributes.fullName: name,
        'cardType': cardType,
        'validity': validity,
        'cpf': cpf,
      }),
    );

    if (response.body == 'null') return;

    final String id = jsonDecode(response.body)['name'];

    final response2 = await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/admins/00000000000/cardRequests/$id/.json"),
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response2.body == 'null') return;

    final databaseID = MyUser.removeCaracteres(cpf);

    await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$databaseID/cards/analisys/$id.json"),
      body: jsonEncode({
        UserAttributes.fullName: name,
        'cardType': cardType,
        'validity': validity,
        'status': 'Em análise',
      }),
    );

    final newRequest = CardRequest(
      id: id,
      cardType: cardType,
      name: name,
      validity: validity,
      status: 'Em análise',
      cpf: cpf,
    );

    //client.addCardRequest(newRequest);
    _myRequests.add(newRequest);

    notifyListeners();
  }

  //TODO: REFATORAR: MOVER PARA MODELS
  void createNewCard(CardRequest cardRequest) async {
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

    final databaseID = MyUser.removeCaracteres(cardRequest.cpf);

    //TODO: verificar se deu certo inserir
    final response = await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/clients/$databaseID/cards/myCards/$cvc.json"),
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

  Future<void> removeCard(BankCard card) async {
    final databaseID =
        MyUser.removeCaracteres(AuthFirebaseService().currentClient!.cpf);

    final response = await http.delete(
      Uri.parse(
          '${Constants.baseUrl}/clients/$databaseID/cards/myCards/${card.cvc}.json'),
    );
    //TOOD: retornar true para verificar se foi possível remover do firebase ou não, caso o status code for diferente de 200
    if (response.statusCode == 200) {
      //client.removeCard(card);
      _myCards.remove(card);
    }

    notifyListeners();
  }

  void removeRefusedCardRequest(CardRequest request) async {
    final databaseID =
        MyUser.removeCaracteres(AuthFirebaseService().currentClient!.cpf);

    //apagar o cartão no banco de dados do cliente
    await http.delete(Uri.parse(
        "${Constants.baseUrl}/clients/$databaseID/cards/analisys/${request.id}.json"));

    //client.removeRequest(request);
    _myRequests.remove(request);

    notifyListeners();
  }

  Future<void> loadMyCards() async {
    final databaseID =
        MyUser.removeCaracteres(AuthFirebaseService().currentClient!.cpf);
    //client.clearMyCards();
    _myCards.clear();

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/clients/$databaseID/cards/myCards.json"),
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
        );

        //client.addCard(card);
        _myCards.add(card);
        _allCardNumbers.add(cards[CardAttributes.number]);
      });
    }

    notifyListeners();
  }

  Future<void> loadCardRequests() async {
    final databaseID =
        MyUser.removeCaracteres(AuthFirebaseService().currentClient!.cpf);
    //client.clearCardRequests();
    _myRequests.clear();

    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/clients/$databaseID/cards/analisys.json"),
    );

    if (response.body != 'null') {
      Map<String, dynamic> cardRequestsData = jsonDecode(response.body);

      cardRequestsData.forEach((key, request) {
        final newRequest = CardRequest(
          cardType: request['cardType'],
          name: request['fullName'],
          status: request['status'],
          id: key,
          validity: request['validity'],
          cpf: databaseID,
          refusalReason: request['refusalReason'],
        );

        //client.addCardRequest(newRequest);
        _myRequests.add(newRequest);
      });
    }

    notifyListeners();
  }
}
