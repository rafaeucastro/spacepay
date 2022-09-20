import 'package:flutter/material.dart';

abstract class CardType {
  static const savings = "Poupança";
  static const checking = "Corrente";
}

class CardTypeDropDown extends StatefulWidget {
  // final void Function(dynamic)? onChanged;
  const CardTypeDropDown({Key? key}) : super(key: key);

  @override
  State<CardTypeDropDown> createState() => _CardTypeDropDownState();
}

class _CardTypeDropDownState extends State<CardTypeDropDown> {
  final List<String> CardType = [
    "Visa",
    "MasterCard",
    "Elo",
    "HiperCard",
    "AmericanExpress"
  ];
  String dropdownValue = "Visa";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      items: CardType.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (object) {
        setState(() {
          dropdownValue = object.toString();
        });
      },
    );
  }
}
