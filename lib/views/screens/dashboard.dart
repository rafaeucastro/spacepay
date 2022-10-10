// ignore_for_file: unused_local_variable

import 'package:banksys/models/card.dart';
import 'package:banksys/models/cards_requests.dart';
import 'package:banksys/models/user.dart';
import 'package:banksys/views/components.dart/bank_card.dart';
import 'package:banksys/views/components.dart/client_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../util/routes.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _key = GlobalKey();
  double _bottomKeyboardMargin = 0;

  void _clientInfo(Client client) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClientInfo(client, context);
      },
    );
  }

  _showModalJustification() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.blue.shade100,
          height: 200 + _bottomKeyboardMargin,
          child: Column(
            children: [
              Text("Qual o motivo??",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  )),
              TextField(
                onTap: () => setState(() {
                  _bottomKeyboardMargin =
                      MediaQuery.of(context).viewInsets.bottom;
                }),
                onChanged: (value) {
                  setState(() {
                    _bottomKeyboardMargin =
                        MediaQuery.of(context).viewInsets.bottom;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Justificativa',
                ),
                textInputAction: TextInputAction.send,
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
    Provider.of<BankCardRequests>(context, listen: false).loadRequests(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final users = Provider.of<Users>(context);
    final newCardRequests =
        Provider.of<BankCardRequests>(context).newCardRequests;
    final registeredCardRequests =
        Provider.of<BankCardRequests>(context).registeredCardsRequests;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(child: Text("Dashboard")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text("Clientes"),
            Expanded(
              child: ListView.builder(
                itemCount: Users.clients.length,
                itemBuilder: (context, index) {
                  final user = Users.clients.elementAt(index);

                  return ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                    onTap: () => _clientInfo(user),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text('Solicitações'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: newCardRequests.length,
                      itemBuilder: (context, index) {
                        final request = newCardRequests.elementAt(index);

                        return Column(
                          children: [
                            ListTile(
                              trailing: const Icon(Icons.credit_card),
                              title: Text(request.name),
                              subtitle: Text(request.cardType),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  highlightColor: Colors.black,
                                  splashColor: Colors.black,
                                  onTap: () {
                                    Provider.of<BankCardRequests>(context,
                                            listen: false)
                                        .confirmNewCardRequest(
                                            request, context);
                                  },
                                  child: Row(children: const [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Aprovar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: InkWell(
                                    highlightColor: Colors.black,
                                    splashColor: Colors.black,
                                    onTap: () {
                                      _showModalJustification();
                                    },
                                    child: Row(children: const [
                                      Icon(Icons.clear),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Recusar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: registeredCardRequests.length,
                      itemBuilder: (context, index) {
                        final card = registeredCardRequests.elementAt(index);

                        return Column(
                          children: [
                            ListTile(
                              trailing: const Icon(Icons.credit_card),
                              title: Text(card.cardholderName),
                              subtitle: Text(card.number),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  highlightColor: Colors.black,
                                  splashColor: Colors.black,
                                  onTap: () {
                                    Provider.of<BankCardRequests>(context,
                                            listen: false)
                                        .confirmRegisteredCardRequest(
                                            card, context);
                                  },
                                  child: Row(children: const [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Aprovar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: InkWell(
                                    highlightColor: Colors.black,
                                    splashColor: Colors.black,
                                    onTap: () {
                                      _showModalJustification();
                                    },
                                    child: Row(children: const [
                                      Icon(Icons.clear),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Recusar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
