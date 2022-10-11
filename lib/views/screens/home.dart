import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/util/routes.dart';
import 'package:spacepay/views/components.dart/card_info_bottom_sheet.dart';
import 'package:spacepay/views/components.dart/new_card_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cards.dart';

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

  //TODO: salvar a imagem no firebase
  void _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    );

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  void _showUserOptionsDialog(Size size, ThemeData theme) {
    final auth = Provider.of<Auth>(context, listen: false);

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: theme.colorScheme.primary,
          child: Container(
            height: size.height * 0.4,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.clear,
                          color: theme.colorScheme.onSecondary),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text('SpacePay'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: _storedImage != null
                      ? Image.file(
                          _storedImage!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                        )
                      : Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimary,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    auth.client?.fullName ?? "Sem nome",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "Excluir conta definitivamente",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Cards>(context, listen: false)
        .loadCardList(context)
        .then((value) => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final registeredCards = Provider.of<Cards>(context).userRegisteredCards;
    final createdCards = Provider.of<Cards>(context).userCreatedCards;
    final auth = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
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
              auth.client?.fullName ?? "Sem nome",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              auth.client?.email ?? "Sem e-mail",
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
                  child: const Text("Sair"),
                  onTap: () {
                    navigator.pushReplacementNamed(AppRoutes.LOGIN);
                    auth.logout();
                  },
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Cards>(context, listen: false)
            .loadCardList(context)
            .then((value) => _isLoading = false),
        child: Column(
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
                    padding:
                        EdgeInsets.only(left: 15.0, bottom: 10.0, top: 15.0),
                    child: Text(CardType.createdCards),
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
                                subtitle: Text(
                                  card.isApproved
                                      ? "**** ${card.numberLastDigits}"
                                      : "**** ****",
                                ),
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
      floatingActionButton: IconButton(
        icon: Icon(Icons.add_card, size: size.width * 0.1),
        onPressed: () {
          _showModal();
        },
      ),
    );
  }
}
