import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/providers/cards_requests.dart';

import '../../models/card_request.dart';

class JustificationModal extends StatefulWidget {
  final CardRequest card;

  const JustificationModal(this.card, {super.key});

  @override
  State<JustificationModal> createState() => _JustificationModalState();
}

class _JustificationModalState extends State<JustificationModal> {
  final GlobalKey<FormState> key = GlobalKey();
  String reason = '';

  void _onSubmitted() {
    key.currentState!.save();
    if (reason.isEmpty) return;

    Provider.of<BankCardRequests>(context, listen: false)
        .refuseCardRequest(reason, widget.card, context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      height: size.height * 0.2 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 10,
        right: 10,
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Informe o motivo da recusa",
            style: theme.textTheme.titleMedium,
          ),
          Form(
            key: key,
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Motivo"),
              onSaved: (newValue) {
                reason = newValue!;
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width * 0.4, size.height * 0.051),
            ),
            onPressed: _onSubmitted,
            child: const Text("ENVIAR"),
          ),
        ],
      ),
    );
  }
}
