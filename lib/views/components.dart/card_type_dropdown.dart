import 'package:flutter/material.dart';

class CardTypeDropDown extends StatelessWidget {
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
      decoration: const InputDecoration(
        label: Text(
          "Tipo de cartão",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
