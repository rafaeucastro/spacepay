import 'package:flutter/material.dart';

// abstract class CardType {
//   static const elo = "Elo";
//   static const visa = "Corrente";
//   static const mastercard = "MasterCard";
//   static const hipercard = "HiperCard";
//   static const americanExpress = "AmericanExpress";
// }

class CardTypeDropDown extends StatelessWidget {
  // final List<String> cardType = [
  //   "Visa",
  //   "MasterCard",
  //   "Elo",
  //   "HiperCard",
  //   "AmericanExpress"
  // ];
  // String dropdownValue = "Visa";

  final void Function(String?)? onChanged;
  final List<String> cardType;
  final String dropdownValue;
  const CardTypeDropDown({
    required this.onChanged,
    required this.cardType,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      items: cardType.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
