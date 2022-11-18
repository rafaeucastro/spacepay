import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/models/card_request.dart';
import 'package:spacepay/providers/cards.dart';
import 'package:spacepay/views/components.dart/new_card_info_bottom_sheet.dart';

class MyCardRequests extends StatelessWidget {
  const MyCardRequests({super.key});

  void _showRequestInfo(CardRequest request, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CardRequestInfo(request, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Solicitações"),
      ),
      body: SafeArea(
          child: Center(
        child: RefreshIndicator(
          onRefresh: () =>
              Provider.of<Cards>(context, listen: false).loadCardRequests(),
          child: FutureBuilder(
            future:
                Provider.of<Cards>(context, listen: false).loadCardRequests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final myRequests = Provider.of<Cards>(context).myRequests;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        final request = myRequests.elementAt(index);
                        return ListTile(
                          leading: const Icon(Icons.add_card),
                          title: Text(request.name),
                          subtitle: Text(
                              "Tipo: ${request.cardType}  -  Validade: ${request.validity} anos"),
                          trailing: Text(request.status),
                          onTap: () => _showRequestInfo(request, context),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )),
    );
  }
}
