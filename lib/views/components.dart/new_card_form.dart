import 'package:banksys/models/card.dart';
import 'package:banksys/views/components.dart/card_type_dropdown.dart';
import 'package:flutter/material.dart';

class NewCardForm extends StatefulWidget {
  const NewCardForm({Key? key}) : super(key: key);

  @override
  State<NewCardForm> createState() => _NewCardFormState();
}

class _NewCardFormState extends State<NewCardForm> {
  String _dropdownValue = CardType.credit;

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

    return Container(
      height: size.height * 0.34,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: theme.colorScheme.onSecondary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Solicitar novo cartão",
            style: theme.textTheme.headlineSmall,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nome completo do titular',
            ),
            textInputAction: TextInputAction.next,
          ),
          CardTypeDropDown(
            onChanged: (p0) {},
            cardType: CardType.all,
            dropdownValue: _dropdownValue,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width * 0.4, size.height * 0.051),
            ),
            onPressed: () {
              _showDialog();
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }
}
