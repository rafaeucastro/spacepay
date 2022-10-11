import 'package:spacepay/models/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cards.dart';

class CardInfo extends StatelessWidget {
  final BankCard card;
  final BuildContext context;
  final String type;
  const CardInfo(this.card, this.context, this.type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.45,
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dados do cartão",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textScale * 20,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        //TODO: se não der certo excluir, notificar usuário
                        Provider.of<Cards>(context, listen: false)
                            .removeCard(card, type, context);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nome"),
              Text(
                card.cardholderName,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Número"),
              Text(
                card.number,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Validade"),
              Text(card.expiryDate,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Código de Segurança"),
              Text(
                card.cvc.toString(),
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 40),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
