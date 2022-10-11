import 'package:flutter/material.dart';

class PersonalizedDropDown extends StatelessWidget {
  final void Function(String?)? onChanged;
  final String? label;
  final List<String> list;
  final String dropdownValue;

  const PersonalizedDropDown({
    this.label,
    this.onChanged,
    required this.list,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      dropdownColor: colorScheme.primary,
      focusColor: colorScheme.secondary,
      iconEnabledColor: colorScheme.secondary,
      value: dropdownValue,
      items: list.map((string) {
        return DropdownMenuItem(
          value: string,
          child: Text(string.toString()),
        );
      }).toList(),
      decoration: label == null
          ? null
          : InputDecoration(
              fillColor: colorScheme.secondary,
              focusColor: Colors.amber,
              label: Text(
                label!,
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
      onChanged: onChanged,
    );
  }
}
