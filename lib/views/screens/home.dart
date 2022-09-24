import 'package:banksys/models/card.dart';
import 'package:banksys/util/routes.dart';
import 'package:banksys/views/components.dart/card_info_bottom_sheet.dart';
import 'package:banksys/views/components.dart/new_card_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cards.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final String _cardTypeImage = "assets/images/elo_logo.png";
  bool _isUnderAnalysis = true;
  bool _isLoading = true;

  void _showCardInfo(BankCard card) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CardInfo(card, context),
    );
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const NewCardForm();
      },
      isScrollControlled: true,
    );
  }

  void _showUserOptionsDialog(Size size, ThemeData theme) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: theme.colorScheme.primary,
          child: Container(
            height: size.height * 0.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.clear),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('SpacePay'),
                  ),
                ],
              ),
              ListTile(
                leading: Image.asset(
                  CardFlag.eloImage,
                  scale: 5,
                ),
                title: const Text("Jessé"),
                subtitle: const Text("jessévicente096@gmail.com"),
              ),
              const Text("Adicionar ou trocar foto do perfil"),
              const Text("Excluir conta definitivamente"),
            ]),
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Image.asset(CardFlag.eloImage),
          onPressed: () {
            _showUserOptionsDialog(size, theme);
          },
        ),
        title: const Text("Rafael"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: SizedBox(
              height: size.height * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showModal();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_card,
                              color: theme.colorScheme.onPrimary,
                            ),
                            const Text("Solicitar cartão"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.ADD_EXISTING_CARD);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_card,
                              color: theme.colorScheme.onPrimary,
                            ),
                            Text(
                              "  Cadastrar\nnovo cartão",
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, bottom: 10.0, top: 15.0),
                  child: Text("Cartões criados"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userCreatedCards.length,
                    itemBuilder: (context, index) {
                      final BankCard card = userCreatedCards.elementAt(index);

                      return ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(card.cardholderName),
                        subtitle: Text("**** ${card.numberLastDigits}"),
                        trailing: const Text(
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 10.0, top: 15.0),
                  child: Row(
                    children: const [
                      Text("Cartões cadastrados"),
                    ],
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: cardList.length,
                          itemBuilder: (context, index) {
                            final BankCard card = cardList.elementAt(index);

                            return ListTile(
                              leading: const Icon(Icons.credit_card),
                              title: Text(card.cardholderName),
                              subtitle: Text("**** ${card.numberLastDigits}"),
                              trailing: _isUnderAnalysis
                                  ? const Text(
                                      "Em análise",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.delete_forever),
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
      floatingActionButton: IconButton(
        icon: Icon(Icons.add_card, size: size.width * 0.1),
        onPressed: () {
          _showModal();
        },
      ),
    );
  }
}
