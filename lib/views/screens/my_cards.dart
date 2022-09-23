// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/card.dart';
import '../../models/cards.dart';

class MyCards extends StatefulWidget {
  const MyCards({Key? key}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final String _cardTypeImage = "assets/images/elo_logo.png";
  bool _isUnderAnalysis = true;
  bool _isLoading = true;

  void _showCardInfo(BankCard card) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final textScale = MediaQuery.of(context).textScaleFactor;
        final size = MediaQuery.of(context).size;

        return Container(
          height: size.height * 0.45,
          padding: EdgeInsets.all(20),
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Provider.of<Cards>(context, listen: false)
                          .removeExistingCard(card);
                    },
                    child: Text(
                      "excluir cartão",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: textScale * 14,
                      ),
                    ),
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
                    card.numberAsString,
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Cards>(context, listen: false)
        .loadCardList()
        .then((value) => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final cards = Provider.of<Cards>(context);
    final cardList = Provider.of<Cards>(context).cardList;
    final userCreatedCards = Provider.of<Cards>(context).userCreatedCars;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus cartões"),
      ),
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, bottom: 10.0, top: 15.0),
                    child: Text("Cartões criados"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userCreatedCards.length,
                      itemBuilder: (context, index) {
                        final BankCard card = userCreatedCards.elementAt(index);

                        return ListTile(
                          leading: Icon(Icons.credit_card),
                          title: Text(card.cardholderName),
                          subtitle: Text("**** ${card.numberLastDigits}"),
                          trailing: Text(
                            "Aprovado",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.425,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, bottom: 10.0, top: 15.0),
                    child: Row(
                      children: const [
                        Text("Cartões cadastrados"),
                      ],
                    ),
                  ),
                  ListTile(
                    leading:
                        Image.asset(_cardTypeImage, width: size.width * 0.1),
                    title: Text("Rafael de Sousa Castro"),
                    subtitle: Text("**** 1122"),
                    trailing: IconButton(
                      icon: Icon(Icons.settings, size: 20),
                      onPressed: () {},
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: cardList.length,
                            itemBuilder: (context, index) {
                              final BankCard card = cardList.elementAt(index);

                              return ListTile(
                                leading: Icon(Icons.credit_card),
                                title: Text(card.cardholderName),
                                subtitle: Text("**** ${card.numberLastDigits}"),
                                trailing: _isUnderAnalysis
                                    ? Text(
                                        "Em análise",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () {
                                          setState(() {});
                                        }),
                                onTap: () => _showCardInfo(card),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
