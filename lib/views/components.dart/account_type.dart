import 'package:flutter/material.dart';

class AccountTypeDropDown extends StatefulWidget {
  // final void Function(dynamic)? onChanged;
  const AccountTypeDropDown({Key? key}) : super(key: key);

  @override
  State<AccountTypeDropDown> createState() => _AccountTypeDropDownState();
}

class _AccountTypeDropDownState extends State<AccountTypeDropDown> {
  final List<String> accountType = ["Poupança", "Corrente"];
  String dropdownValue = "Poupança";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      items: accountType.map((type) {
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
