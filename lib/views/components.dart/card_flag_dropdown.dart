import 'package:flutter/material.dart';

class CardFlagDropDown extends StatelessWidget {
  // final List<String> cardFlag = [
  //   "Visa",
  //   "MasterCard",
  //   "Elo",
  //   "HiperCard",
  //   "AmericanExpress"
  // ];
  // String dropdownValue = "Visa";

  final void Function(String?)? onChanged;
  final List<String> cardFlag;
  final String dropdownValue;
  const CardFlagDropDown({
    required this.onChanged,
    required this.cardFlag,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      items: cardFlag.map((flag) {
        return DropdownMenuItem(
          value: flag,
          child: Text(flag),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
