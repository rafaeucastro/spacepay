import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/models/users.dart';
import 'package:spacepay/util/routes.dart';
import 'package:spacepay/views/components.dart/card_info_bottom_sheet.dart';
import 'package:spacepay/views/components.dart/new_card_form.dart';

import '../../models/cards.dart';
import '../components.dart/user_photo_dialog.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields
  bool _isLoading = true;
  File? _storedImage;

  void _showCardInfo(BankCard card, String type) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CardInfo(card, context, type),
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

  void _takePicture() async {
    _storedImage = await Provider.of<Users>(context, listen: false)
        .setUserProfilePicture();

    if (_storedImage == null) return;
    setState(() {});
  }

  void _showUserOptionsDialog(Size size, ThemeData theme) {
    final auth = Provider.of<Auth>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return UserPhotoDialog(storedImage: _storedImage, auth: auth);
      },
    );
  }

  void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
  }

  Future<void> _loadProfilePicture() async {
    _storedImage =
        await Provider.of<Users>(context, listen: false).loadProfilePicture();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Cards>(context, listen: false)
        .loadCardList(context)
        .then((value) => _isLoading = false);

    _loadProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final registeredCards = Provider.of<Cards>(context).userRegisteredCards;
    final createdCards = Provider.of<Cards>(context).userCreatedCards;
    final loggedClient = Provider.of<Auth>(context, listen: false).client;
    //print(_storedImage!.path);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: _storedImage != null
              ? CircleAvatar(
                  backgroundImage: FileImage(
                    _storedImage!,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimary,
                ),
          onPressed: () {
            _showUserOptionsDialog(size, theme);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loggedClient?.fullName ?? "Sem nome",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              loggedClient?.email ?? "Sem e-mail",
              style: theme.textTheme.subtitle2,
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            color: theme.colorScheme.primary,
            itemBuilder: (context) {
              return [
                PopupMenuItem<Text>(
                  child: const Text("Configurações"),
                  onTap: () {},
                ),
                PopupMenuItem<Text>(
                  onTap: _takePicture,
                  child: const Text("Alterar foto do perfil"),
                ),
                PopupMenuItem<Text>(
                  onTap: _logout,
                  child: const Text("Sair"),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      //TODO: usar consumer e future builder
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Cards>(context, listen: false)
            .loadCardList(context)
            .then((value) => _isLoading = false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        borderRadius: BorderRadius.circular(10),
                        splashColor: theme.colorScheme.secondary,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
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
                        borderRadius: BorderRadius.circular(10),
                        splashColor: theme.colorScheme.secondary,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, bottom: 10.0, top: 15.0),
                    child: Row(
                      children: const [
                        Text(CardType.createdCards),
                      ],
                    ),
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: createdCards.length,
                            itemBuilder: (context, index) {
                              final BankCard card =
                                  createdCards.elementAt(index);

                              return ListTile(
                                leading: const Icon(Icons.credit_card),
                                title: Text(card.cardholderName),
                                subtitle: Text("**** ${card.numberLastDigits}"),
                                trailing: Text(
                                  card.status,
                                  style: TextStyle(
                                    color: card.isApproved
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.primary,
                                  ),
                                ),
                                onTap: () =>
                                    _showCardInfo(card, CardType.createdCards),
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
                        Text(CardType.registeredCards),
                      ],
                    ),
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: registeredCards.length,
                            itemBuilder: (context, index) {
                              final BankCard card =
                                  registeredCards.elementAt(index);

                              return ListTile(
                                leading: const Icon(Icons.credit_card),
                                title: Text(card.cardholderName),
                                subtitle: Text("**** ${card.numberLastDigits}"),
                                trailing: Text(
                                  card.status,
                                  style: TextStyle(
                                    color: card.isApproved
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.primary,
                                  ),
                                ),
                                onTap: () => _showCardInfo(
                                    card, CardType.registeredCards),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showModal,
        child: Icon(Icons.add_card, size: size.width * 0.1),
      ),
    );
  }
}
