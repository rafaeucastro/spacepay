import 'package:flutter/material.dart';

import '../../models/user.dart';

class AccountTypeDropDown extends StatefulWidget {
  final Map<String, String> formData;
  const AccountTypeDropDown({
    required this.formData,
    Key? key,
  }) : super(key: key);

  @override
  State<AccountTypeDropDown> createState() => _AccountTypeDropDownState();
}

class _AccountTypeDropDownState extends State<AccountTypeDropDown> {
  String dropdownValue = "Poupança";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      dropdownColor: colorScheme.primary,
      value: dropdownValue,
      items: AccountType.accountTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type,
            style: TextStyle(color: colorScheme.onPrimary),
          ),
        );
      }).toList(),
      onSaved: (newValue) {
        widget.formData['accountType'] = newValue.toString();
      },
      onChanged: (object) {
        setState(() {
          dropdownValue = object.toString();
        });
      },
    );
  }
}
