import 'dart:convert';
import 'dart:math';

import 'package:banksys/models/card.dart';
import 'package:banksys/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cards with ChangeNotifier {
  // ignore: prefer_final_fields
  List<BankCard> _userCreatedCards = [];
  // ignore: prefer_final_fields
  List<BankCard> _userRegisteredCards = [
    BankCard(
      cardholderName: "Rafael Castro",
      cvc: 303,
      expiryDate: "12/26",
      flag: CardFlag.hipercard,
      number: '1234 5678 9123 4567',
    )
  ];
  List<String> _allCardNumbers = [];
  List<int> _allCVCs = [];

  List<BankCard> get userRegisteredCards => [..._userRegisteredCards];
  List<BankCard> get userCreatedCards => [..._userCreatedCards];

  void addExistingCard(Map<String, String> formData) async {
    final number = formData[CardAttributes.number]!;
    final cvc = formData[CardAttributes.cvc]!;
    final cardholderName = formData[CardAttributes.cardholderName]!;
    final expiryDate = formData[CardAttributes.expiryDate]!;
    final flag = formData[CardAttributes.flag]!;

    final response = await http.post(
      Uri.parse(Constants.urlExistingCards),
      body: jsonEncode({
        CardAttributes.cardholderName: cardholderName,
        CardAttributes.number: number,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
        CardAttributes.flag: flag,
      }),
    );

    final id = jsonDecode(response.body)['name'].toString();

    final newCard = BankCard(
      cardholderName: cardholderName,
      expiryDate: expiryDate,
      flag: flag,
      number: number,
      cvc: int.parse(cvc),
      databaseID: id,
    );

    _userRegisteredCards.add(newCard);
    notifyListeners();
  }

  void createNewCard(String name, String cardType, String validity) async {
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
    final response = await http.post(
      Uri.parse(Constants.urlCreatedCards),
      body: jsonEncode({
        CardAttributes.cardholderName: name,
        CardAttributes.number: cardNumber,
        CardAttributes.flag: flag,
        CardAttributes.expiryDate: expiryDate,
        CardAttributes.cvc: cvc,
      }),
    );

    final id = jsonDecode(response.body)['name'].toString();

    final newCard = BankCard(
      number: cardNumber,
      cardholderName: name,
      expiryDate: expiryDate,
      cvc: cvc,
      flag: flag,
      databaseID: id,
    );

    _userCreatedCards.add(newCard);

    notifyListeners();
  }

  Future<void> removeCard(BankCard card, String type) async {
    switch (type) {
      case CardType.createdCards:
        final response = await http.delete(
          Uri.parse('${Constants.urlCreatedCards}/${card.databaseID}.json'),
        );
        //TOOD: retornar true para verificar se foi possível remover do firebase ou não, caso o status code for diferente de 200
        if (response.statusCode == 200) {
          _userCreatedCards.remove(card);
        }
        break;
      case CardType.registeredCards:
        final response = await http.delete(
          Uri.parse('${Constants.urlExistingCards}/${card.databaseID}.json'),
        );
        if (response.statusCode == 200) {
          _userCreatedCards.remove(card);
        }
        break;
    }

    // print("id: ${card.databaseID}");
    // print("response: ${jsonDecode(response.statusCode.toString())}");

    notifyListeners();
  }

  Future<void> loadCardList() async {
    _userCreatedCards.clear();
    _userRegisteredCards.clear();

    final response = await http.get(
      Uri.parse(Constants.urlCreatedCards),
    );
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, cards) {
      _userCreatedCards.add(BankCard(
        cardholderName: cards[CardAttributes.cardholderName],
        expiryDate: cards[CardAttributes.expiryDate],
        flag: cards[CardAttributes.flag],
        number: cards[CardAttributes.number],
        cvc: cards[CardAttributes.cvc],
        databaseID: key,
      ));
      _allCardNumbers.add(cards[CardAttributes.number]);
    });

    final response2 = await http.get(
      Uri.parse(Constants.urlExistingCards),
    );
    if (response2.body == 'null') return;

    Map<String, dynamic> data2 = jsonDecode(response2.body);
    data2.forEach((key, cards) {
      _userRegisteredCards.add(BankCard(
        cardholderName: cards[CardAttributes.cardholderName],
        expiryDate: cards[CardAttributes.expiryDate],
        flag: cards[CardAttributes.flag],
        number: cards[CardAttributes.number],
        cvc: int.parse(cards[CardAttributes.cvc]),
        databaseID: key,
      ));
      _allCardNumbers.add(cards[CardAttributes.number]);
    });

    notifyListeners();
  }
}
