import 'package:banksys/models/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cards with ChangeNotifier {
  List<BankCard> _cardList = [
    BankCard(
      cardholderName: "Rafael Castro",
      cvc: 303,
      expiryDate: "12/26",
      flag: CardFlag.hipercard,
      number: 1234567891234567,
    )
  ];

  List<BankCard> get cardList => [..._cardList];

  void addExistingCard(Map<String, String> formData) {
    final number = formData[CardAttributes.number]!.split(' ').join();
    final cvc = formData[CardAttributes.cvc]!;

    final newCard = BankCard(
      cardholderName: formData[CardAttributes.cardholderName]!,
      expiryDate: formData[CardAttributes.expiryDate]!,
      flag: formData[CardAttributes.flag]!,
      number: int.tryParse(number) ?? 0,
      cvc: int.parse(cvc),
    );

    _cardList.add(newCard);
  }

  void removeCard(BankCard card) {
    _cardList.remove(card);
  }
}
