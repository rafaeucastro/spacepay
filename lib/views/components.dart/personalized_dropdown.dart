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
    return DropdownButtonFormField(
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
              label: Text(
                label!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
      onChanged: onChanged,
    );
  }
}
