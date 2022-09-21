abstract class CardFlag {
  static const elo = "Elo";
  static const visa = "Corrente";
  static const mastercard = "MasterCard";
  static const hipercard = "HiperCard";
  static const americanExpress = "AmericanExpress";
}

class Card {
  final int number;
  final String cardholderName;
  final DateTime expiryDate;
  final int cvc;
  final CardFlag flag;

  const Card({
    required this.number,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvc,
    required this.flag,
  });
}
