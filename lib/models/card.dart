// enum CardFlag {
//   elo,
//   visa,
//   mastercard,
//   hipercard,
//   americanExpress,
// }

import 'dart:math';

abstract class CardAttributes {
  static const number = "number";
  static const cardholderName = "cardholderName";
  static const expiryDate = "expiryDate";
  static const cvc = "cvc";
  static const flag = "flag";
  static const databaseID = "databaseID";
}

//TODO: adicionar opção poupança/débito quando o usuário tiver conta poupança
abstract class CardType {
  static const credit = "Crédito";
  static const debit = "Débito";
  static const savings = "Poupança";
  static const multifuncional = "Multifuncional";
  static const all = [credit, debit, savings, multifuncional];

  static const createdCards = "Cartões criados";
  static const registeredCards = "Cartões registrados";
}

abstract class CardFlag {
  static const elo = "Elo";
  static const visa = "Visa";
  static const mastercard = "MasterCard";
  static const hipercard = "HiperCard";
  static const americanExpress = "AmericanExpress";

  static const eloImage = "assets/images/elo_logo.png";
  static const visaTextImage = "assets/images/visa_logo_text.png";
  static const visaImage = "assets/images/visa_logo.png";
  static const hipercardImage = "assets/images/hipercard_logo.png";
  static const mastercardImage = "assets/images/mastercard_logo.png";
  static const americanExpressTextImage =
      "assets/images/american_express_logo_text.png";
  static const americanExpressImage = "assets/images/american_express_logo.png";

  static const all = [
    CardFlag.elo,
    CardFlag.visa,
    CardFlag.mastercard,
    CardFlag.hipercard,
    CardFlag.americanExpress,
  ];

  static String get randomFlag {
    var flag = [...CardFlag.all];
    flag.shuffle();
    return flag.first;
  }

  // static CardFlag tryParse(String flag) {
  //   if (flag == "Elo") return CardFlag.elo;
  // }
  static Map<String, double> switchFlagImage({
    required String identification,
    required String flagImage,
    required double imageScale,
  }) {
    switch (identification) {
      case CardFlag.elo:
        flagImage = CardFlag.eloImage;
        imageScale = 4;
        break;
      case CardFlag.visa:
        flagImage = CardFlag.visaImage;
        imageScale = 4;
        break;
      case CardFlag.hipercard:
        flagImage = CardFlag.hipercardImage;
        imageScale = 28;
        break;
      case CardFlag.mastercard:
        flagImage = CardFlag.mastercardImage;
        imageScale = 24;
        break;
      case CardFlag.americanExpress:
        flagImage = CardFlag.americanExpressTextImage;
        imageScale = 10;
        break;
      default:
    }

    return {flagImage: imageScale};
  }
}

//TODO: make attributes private
class BankCard {
  final String number;
  final String cardholderName;
  final String expiryDate;
  final int cvc;
  final String flag;
  String? databaseID;
  String flagImage = CardFlag.eloImage;
  double flagImageScale = 4.0;

  BankCard({
    required this.number,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvc,
    required this.flag,
    this.databaseID,
  }) {
    _defineCardFlagImage();
  }

  String get numberLastDigits {
    return number.substring(number.length - 4, number.length);
  }

  String get numberWithoutSpaces {
    return number.split(' ').join();
  }

  static String get generateRamdomCardNumber {
    final String number1 = (Random().nextInt(8999) + 1000).toString();
    final String number2 = (Random().nextInt(8999) + 1000).toString();
    final String number3 = (Random().nextInt(8999) + 1000).toString();
    final String number4 = (Random().nextInt(8999) + 1000).toString();

    return "$number1 $number2 $number3 $number4";
  }

  static String getExpiryDate(String validity) {
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString().substring(2, 4);

    if (int.parse(month) < 10) {
      month = "0$month";
    }

    year = (int.parse(year) + int.parse(validity)).toString();

    return "$month/$year";
  }

  void _defineCardFlagImage() {
    switch (flag) {
      case CardFlag.elo:
        flagImage = CardFlag.eloImage;
        flagImageScale = 4;
        break;
      case CardFlag.visa:
        flagImage = CardFlag.visaTextImage;
        flagImageScale = 12;
        break;
      case CardFlag.hipercard:
        flagImage = CardFlag.hipercardImage;
        flagImageScale = 30;
        break;
      case CardFlag.mastercard:
        flagImage = CardFlag.mastercardImage;
        flagImageScale = 26;
        break;
      case CardFlag.americanExpress:
        flagImage = CardFlag.americanExpressImage;
        flagImageScale = 12;
        break;
      default:
    }
  }
}
