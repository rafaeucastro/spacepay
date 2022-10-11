import 'dart:convert';
import 'dart:math';

import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/models/constants.dart';
import 'package:spacepay/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Cards with ChangeNotifier {
  // ignore: prefer_final_fields
  List<BankCard> _userCreatedCards = [];
  // ignore: prefer_final_fields
  List<BankCard> _userRegisteredCards = [];
  // ignore: prefer_final_fields
  List<String> _allCardNumbers = [];
  // ignore: prefer_final_fields
  List<int> _allCVCs = [];

  List<BankCard> get userRegisteredCards => [..._userRegisteredCards];
  List<BankCard> get userCreatedCards => [..._userCreatedCards];

  void addExistingCard(
      Map<String, String> formData, BuildContext context) async {
    final number = formData[CardAttributes.number]!;
    final cvc = int.parse(formData[CardAttributes.cvc]!);
    final cardholderName = formData[CardAttributes.cardholderName]!;
    final expiryDate = formData[CardAttributes.expiryDate]!;
    final flag = formData[CardAttributes.flag]!;

    final clientDatabaseID =
        Provider.of<Auth>(context, listen: false).client!.databaseID;
    if (clientDatabaseID == null) return;

    //TODO: usar userID como identificador do mapa no firebase.
    final response = await http.patch(
      Uri.parse(
          "${Constants.baseUrl}/admins/-NCl0gUqE_K4QWFn-Qyu/requests/${UserAttributes.registeredCards}/$cvc.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: cardholderName,
        CardAttributes.number: number,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
        CardAttributes.flag: flag,
        CardAttributes.status: "Em análise",
        CardAttributes.databaseID: clientDatabaseID,
      }),
    );

    final newCard = BankCard(
      cardholderName: cardholderName,
      expiryDate: expiryDate,
      flag: flag,
      number: number,
      cvc: cvc,
    );

    _userRegisteredCards.add(newCard);
    notifyListeners();
  }

  void sendCardForAnalysis(String name, String cardType, String validity,
      BuildContext context) async {
    final clientDatabaseID =
        Provider.of<Auth>(context, listen: false).client!.databaseID;

    final response = await http.post(
      Uri.parse(
          "${Constants.baseUrl}/admins/-NCl0gUqE_K4QWFn-Qyu/requests/${UserAttributes.createdCards}.json"),
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
          "${Constants.baseUrl}/admins/-NCl0gUqE_K4QWFn-Qyu/requests/${UserAttributes.createdCards}/$id/.json"),
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response2.body == 'null') return;

    _userCreatedCards.add(
      BankCard(
        number: "**** ****",
        cardholderName: name,
        expiryDate: "**/**",
        cvc: 0,
        flag: "",
      ),
    );

    notifyListeners();
  }

  void createNewCard(String name, String cardType, String validity,
      String userID, BuildContext context) async {
    final String flag = CardFlag.randomFlag;
    final String expiryDate = BankCard.getExpiryDate(validity);
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
          "${Constants.baseUrl}/clients/$userID/${UserAttributes.createdCards}/$cvc.json"),
      body: jsonEncode({
        CardAttributes.cardholderName: name,
        CardAttributes.number: cardNumber,
        CardAttributes.flag: flag,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
        CardAttributes.status: "Aprovado",
      }),
    );

    //TODO: DELETE ALL THIS CODE
    // final id = jsonDecode(response.body)['name'].toString();

    // final newCard = BankCard(
    //   number: cardNumber,
    //   cardholderName: name,
    //   expiryDate: expiryDate,
    //   cvc: cvc,
    //   flag: flag,
    //   databaseID: id,
    // );

    // _userCreatedCards.add(newCard);

    notifyListeners();
  }

  Future<void> removeCard(
      BankCard card, String type, BuildContext context) async {
    final client = Provider.of<Auth>(context, listen: false).client;
    if (client == null) return;

    switch (type) {
      case CardType.createdCards:
        final response = await http.delete(
          Uri.parse(
              '${Constants.baseUrl}/clients/${client.databaseID}/${UserAttributes.createdCards}/${card.cvc}.json'),
        );
        //TOOD: retornar true para verificar se foi possível remover do firebase ou não, caso o status code for diferente de 200
        if (response.statusCode == 200) {
          _userCreatedCards.remove(card);
        }
        break;
      case CardType.registeredCards:
        final response = await http.delete(
          Uri.parse(
              '${Constants.baseUrl}/clients/${client.databaseID}/${UserAttributes.registeredCards}/${card.cvc}.json'),
        );
        if (response.statusCode == 200 || response.statusCode == 404) {
          _userRegisteredCards.remove(card);
        }
        break;
    }

    // print("id: ${card.databaseID}");
    // print("response: ${jsonDecode(response.statusCode.toString())}");

    notifyListeners();
  }

  Future<void> loadCardList(BuildContext context) async {
    List<BankCard> userCreatedCards = [];
    List<BankCard> userRegisteredCards = [];

    final client = Provider.of<Auth>(context, listen: false).client;
    if (client == null) return;

    final response = await http.get(
      Uri.parse(
          "${Constants.baseUrl}/clients/${client.databaseID}/${UserAttributes.createdCards}.json"),
    );

    //TODO: tratar quando vier nulo
    if (response.body != 'null') {
      Map<String, dynamic> createdCardsData = jsonDecode(response.body);

      createdCardsData.forEach((key, cards) {
        final card = BankCard(
          cardholderName: cards[CardAttributes.cardholderName],
          expiryDate: cards[CardAttributes.expiryDate],
          flag: cards[CardAttributes.flag],
          number: cards[CardAttributes.number],
          cvc: cards[CardAttributes.cvc],
          databaseID: key,
          status: cards[CardAttributes.status],
        );

        userCreatedCards.add(card);
        _allCardNumbers.add(cards[CardAttributes.number]);
      });
    }

    final response2 = await http.get(
      Uri.parse(
          "${Constants.baseUrl}/clients/${client.databaseID}/${UserAttributes.registeredCards}.json"),
    );

    if (response2.body != 'null') {
      Map<String, dynamic> registeredCardsData = jsonDecode(response2.body);

      registeredCardsData.forEach((key, cards) {
        final card = BankCard(
          cardholderName: cards[CardAttributes.cardholderName],
          expiryDate: cards[CardAttributes.expiryDate],
          flag: cards[CardAttributes.flag],
          number: cards[CardAttributes.number],
          cvc: cards[CardAttributes.cvc],
          databaseID: key,
          status: cards[CardAttributes.status],
        );

        userRegisteredCards.add(card);
        _allCardNumbers.add(cards[CardAttributes.number]);
      });
    }

    _userCreatedCards = userCreatedCards;
    _userRegisteredCards = userRegisteredCards;
    notifyListeners();
  }
}
