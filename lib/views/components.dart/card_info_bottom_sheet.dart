import 'package:spacepay/models/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/views/components.dart/bank_card.dart';

import '../../providers/cards.dart';

class CardInfo extends StatefulWidget {
  final BankCard card;
  final BuildContext context;
  final String type;
  const CardInfo(this.card, this.context, this.type, {Key? key})
      : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  bool _cardView = false;

  void _toggleView() {
    setState(() {
      _cardView = !_cardView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final BankCard card = widget.card;

    return Container(
      height: size.height * 0.50,
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          .removeCard(widget.card, context);
                    },
                    icon: Icon(Icons.delete, color: theme.primary),
                  ),
                ],
              ),
            ],
          ),
          _cardView
              ? BankCardItem(
                  height: size.height * 0.25,
                  width: size.height * 0.4,
                  cardFlagImage: card.flagImage,
                  cardholderName: card.cardholderName,
                  number: card.number,
                  expireDate: card.expiryDate,
                  imageScale: card.flagImageScale * 2,
                  cvc: card.cvc.toString(),
                )
              : SizedBox(
                  height: size.height * 0.25,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nome", style: textTheme.headline5),
                          Text(
                            widget.card.cardholderName,
                            style: TextStyle(
                              color: theme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Número", style: textTheme.headline5),
                          Text(
                            widget.card.number,
                            style: TextStyle(
                              color: theme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Validade", style: textTheme.headline5),
                          Text(widget.card.expiryDate,
                              style: TextStyle(
                                color: theme.onPrimary,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Código de Segurança",
                              style: textTheme.headline5),
                          Text(
                            widget.card.cvc.toString(),
                            style: TextStyle(
                              color: theme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40),
                ),
                onPressed: _toggleView,
                child: const Text("Pré-visualização"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
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
