import 'package:banksys/models/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cards.dart';

class CardInfo extends StatelessWidget {
  final BankCard card;
  final BuildContext context;
  const CardInfo(this.card, this.context, {Key? key}) : super(key: key);

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
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //     Provider.of<Cards>(context, listen: false)
                  //         .removeExistingCard(card);
                  //   },
                  //   child: Text(
                  //     "Excluir",
                  //     style: TextStyle(
                  //       color: Colors.red,
                  //       fontSize: textScale * 14,
                  //     ),
                  //   ),
                  // ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Provider.of<Cards>(context, listen: false)
                            .removeExistingCard(card);
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nome"),
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
              Text("Número"),
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
              Text("Validade"),
              Text(card.expiryDate,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Código de Segurança"),
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
                child: Text("Fechar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
