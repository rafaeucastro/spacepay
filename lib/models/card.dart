// enum CardFlag {
//   elo,
//   visa,
//   mastercard,
//   hipercard,
//   americanExpress,
// }

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
  final int number;
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
    return number.toString().substring(12, 16);
  }

  String get numberAsString {
    String number = this.number.toString();
    String firstPart = number.substring(0, 4);
    String secondPart = number.substring(4, 8);
    String thirdPart = number.substring(8, 12);
    String fourthPart = number.substring(12, 16);
    number = "$firstPart $secondPart $thirdPart $fourthPart";

    return number;
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
