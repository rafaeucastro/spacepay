import 'package:banksys/models/card.dart';
import 'package:banksys/models/cards.dart';
import 'package:banksys/views/components.dart/card_type_dropdown.dart';
import 'package:banksys/views/components.dart/personalized_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCardForm extends StatefulWidget {
  const NewCardForm({Key? key}) : super(key: key);

  @override
  State<NewCardForm> createState() => _NewCardFormState();
}

class _NewCardFormState extends State<NewCardForm> {
  String _dropdownValue = CardType.credit;
  String _yearDropdownValue = "2";
  final _validYears = ["2", "4", "5", "6"];
  String _name = "";
  double _bottomKeyboardMargin = 0;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Solicitar novo cartão"),
          content: const Text("Seus dados foram enviados para análise. "
              "Agora é só aguardar uma resposta da nossa parte. ;)"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Entendido")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final cards = Provider.of<Cards>(context);

    return Container(
      height: size.height * 0.34 + _bottomKeyboardMargin,
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: _bottomKeyboardMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: theme.colorScheme.secondary,
      ),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Solicitar novo cartão",
              style: theme.textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.60,
                  child: CardTypeDropDown(
                    cardType: CardType.all,
                    dropdownValue: _dropdownValue,
                    onChanged: (cardType) {
                      _dropdownValue = cardType!;
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.30,
                  child: PersonalizedDropDown(
                    list: _validYears,
                    dropdownValue: _yearDropdownValue,
                    label: "Validade",
                    onChanged: (validity) {
                      _yearDropdownValue = validity!;
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome completo do titular',
              ),
              textInputAction: TextInputAction.next,
              onTap: () => setState(() {
                _bottomKeyboardMargin = mediaQuery.viewInsets.bottom;
              }),
              onChanged: (value) {
                _name = value;
                setState(() {
                  _bottomKeyboardMargin = mediaQuery.viewInsets.bottom;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.4, size.height * 0.051),
                primary: theme.colorScheme.onPrimary,
                onPrimary: theme.colorScheme.primary,
              ),
              onPressed: () {
                _showDialog();
                cards.createNewCard(_name, _dropdownValue, _yearDropdownValue);
              },
              child: const Text("ENVIAR"),
            ),
          ],
        ),
      ),
    );
  }
}
