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
  static const status = "status";
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
}

//TODO: make attributes private
class BankCard {
  final String number;
  final String cardholderName;
  final String expiryDate;
  final int cvc;
  final String flag;
  String? userID;
  String flagImage = CardFlag.eloImage;

  BankCard({
    required this.number,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvc,
    required this.flag,
    this.userID,
  }) {
    flagImage = defineCardFlagImage(flag);
  }

  // bool get isApproved {
  //   if (status == "Em análise") {
  //     return false;
  //   }
  //   return true;
  // }

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

  static String defineCardFlagImage(String identification) {
    String flagAsset = CardFlag.visaImage;

    switch (identification) {
      case CardFlag.elo:
        flagAsset = CardFlag.eloImage;
        break;
      case CardFlag.visa:
        flagAsset = CardFlag.visaTextImage;
        break;
      case CardFlag.hipercard:
        flagAsset = CardFlag.hipercardImage;
        break;
      case CardFlag.mastercard:
        flagAsset = CardFlag.mastercardImage;
        break;
      case CardFlag.americanExpress:
        flagAsset = CardFlag.americanExpressImage;
        break;
      default:
    }

    return flagAsset;
  }

  static String validateCardNumber(String number) {
    switch (number.substring(0, 1)) {
      case '2':
        return CardFlag.mastercardImage;
      case '3':
        return CardFlag.americanExpressImage;
      case '4':
        return CardFlag.visaImage;
      case '5':
        return CardFlag.mastercardImage;
      case '6':
        return CardFlag.eloImage;
    }
    return '';
  }
}
