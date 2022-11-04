import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/models/card_request.dart';
import 'package:spacepay/providers/cards.dart';

class CardRequestInfo extends StatelessWidget {
  final CardRequest request;
  final BuildContext context;

  const CardRequestInfo(this.request, this.context, {super.key});

  void _onTap(CardRequest request, BuildContext context) {
    if (request.status == 'Negado') {
      Provider.of<Cards>(context, listen: false)
          .removeRefusedCardRequest(request, context);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: size.height * 0.350,
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dados da sua solicitação",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textScale * 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.18,
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
                      request.name,
                      style: TextStyle(
                        color: theme.onPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tipo do Cartão", style: textTheme.headline5),
                    Text(
                      request.cardType,
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
                    Text(
                      "${request.validity} anos",
                      style: TextStyle(
                        color: theme.onPrimary,
                      ),
                    ),
                  ],
                ),
                if (request.status == 'Negado')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Motivo", style: textTheme.headline5),
                      Text(
                        request.refusalReason ?? "Erro!!!",
                        style: TextStyle(
                          color: theme.onPrimary,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
            ),
            onPressed: () => _onTap(request, context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
