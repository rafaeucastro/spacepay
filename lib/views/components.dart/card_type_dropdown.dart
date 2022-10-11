import 'package:flutter/material.dart';

class CardTypeDropDown extends StatelessWidget {
  final void Function(String?)? onChanged;
  final List<String> cardType;
  final String dropdownValue;

  const CardTypeDropDown({
    this.onChanged,
    required this.cardType,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      dropdownColor: colorScheme.primary,
      focusColor: colorScheme.secondary,
      value: dropdownValue,
      items: cardType.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(
          "Tipo de cartão",
          style: TextStyle(
            color: colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
