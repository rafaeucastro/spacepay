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
  List<BankCard> _cardList = [
    BankCard(
      cardholderName: "Rafael Castro",
      cvc: 303,
      expiryDate: "12/26",
      flag: CardFlag.hipercard,
      number: '1234 5678 9123 4567',
    )
  ];

  List<BankCard> get cardList => [..._cardList];
  List<BankCard> get userCreatedCars => [..._userCreatedCards];

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

    _cardList.add(newCard);
    notifyListeners();
  }

  void createNewCard(String name, String cardType, String validity) {
    final cvc = Random().nextInt(899) + 100;
    final String number1 = (Random().nextInt(8999) + 1000).toString();
    final String number2 = (Random().nextInt(8999) + 1000).toString();
    final String number3 = (Random().nextInt(8999) + 1000).toString();
    final String number4 = (Random().nextInt(8999) + 1000).toString();

    //TODO: gerar número do cartão e bandeira aleatório
    final newCard = BankCard(
      number: "$number1 $number2 $number3 $number4",
      cardholderName: name,
      expiryDate: validity,
      cvc: cvc,
      flag: CardFlag.all.elementAt(1),
    );

    _userCreatedCards.add(newCard);

    notifyListeners();
  }

  Future<void> removeExistingCard(BankCard card) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/${card.databaseID}.json'),
    );

    if (response.statusCode == 200) {
      _cardList.remove(card);
    }

    // print("id: ${card.databaseID}");
    // print("response: ${jsonDecode(response.statusCode.toString())}");

    notifyListeners();
  }

  Future<void> loadCardList() async {
    _cardList.clear();

    final response = await http.get(
      Uri.parse(Constants.urlExistingCards),
    );
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, cards) {
      _cardList.add(BankCard(
        cardholderName: cards[CardAttributes.cardholderName],
        expiryDate: cards[CardAttributes.expiryDate],
        flag: cards[CardAttributes.flag],
        number: cards[CardAttributes.number],
        cvc: int.parse(cards[CardAttributes.cvc]),
        databaseID: key,
      ));
    });

    notifyListeners();
  }
}
