// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyCards extends StatefulWidget {
  const MyCards({Key? key}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final String _cardTypeImage = "assets/images/elo_logo.png";

  void _showCardInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return Container(
          height: size.height * 0.4,
          padding: EdgeInsets.all(20),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dados do cartão",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nome"),
                  Text(
                    "RAFAEL DE SOUSA CASTRO",
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
                    "0890 6734 4327 1122",
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
                  Text("10/24",
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
                    "080",
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus cartões"),
      ),
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: Text("Cartões criados"),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text("Lirio Souza Castro"),
                    subtitle: Text("**** 4779"),
                    trailing: Text(
                      "Aprovado",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: Text("Cartões cadastrados"),
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
                    onTap: _showCardInfo,
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text("Franc. Franciscleidson F. Faminto"),
                    subtitle: Text("**** 0865"),
                    trailing: Text(
                      "Em análise",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
