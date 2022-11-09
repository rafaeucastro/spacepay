import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/views/components.dart/justification_bottom_sheet.dart';

import '../../models/card_request.dart';
import '../../providers/cards_requests.dart';

class ClientRequests extends StatelessWidget {
  //final void Function() showModalJustification;

  const ClientRequests({super.key});

  void _askForJustification(BuildContext context, CardRequest card) {
    showModalBottomSheet(
      context: context,
      builder: (context) => JustificationModal(card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardRequests = Provider.of<BankCardRequests>(context).cardRequests;

    return Column(
      children: [
        cardRequests.isEmpty
            ? const Text(
                "Tudo certo por aqui!\nVocê não tem novas solicitações",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Eczar',
                  fontSize: 24,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: cardRequests.length,
                  itemBuilder: (context, index) {
                    final request = cardRequests.elementAt(index);

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
                                    .confirmCardRequest(request, context);
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
                                onTap: () =>
                                    _askForJustification(context, request),
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
    );
  }
}
