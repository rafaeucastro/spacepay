import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/card.dart';
import 'package:spacepay/providers/users.dart';
import 'package:spacepay/util/routes.dart';
import 'package:spacepay/views/components.dart/card_info_bottom_sheet.dart';
import 'package:spacepay/views/components.dart/new_card_form.dart';

import '../../providers/cards.dart';
import '../components.dart/user_photo_dialog.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields
  bool _isLoading = true;

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
    final File? photo = await Provider.of<Users>(context, listen: false)
        .setUserProfilePicture();

    if (photo == null) return;

    setState(() {});
  }

  void _showUserOptionsDialog(Size size, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return const UserPhotoDialog();
      },
    );
  }

  void _logout() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
  }

  @override
  void initState() {
    super.initState();
    //Provider.of<Cards>(context, listen: false).loadMyCards(context);

    Provider.of<Users>(context, listen: false)
        .loadProfilePicture()
        .then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final client = Provider.of<Auth>(context, listen: false).client;
    final profilePicture = client!.profilePicture;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: profilePicture != null
              ? CircleAvatar(
                  backgroundImage: FileImage(
                    profilePicture,
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
        title: InkWell(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.USER_PROFILE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.fullName,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                client.email,
                style: theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Cards>(context, listen: false).loadMyCards(context),
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
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.CARD_REQUESTS),
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
                                Icons.list,
                                color: theme.colorScheme.onPrimary,
                              ),
                              const Text("Minhas solicitações"),
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
                        Text('Meus cartões'),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: Provider.of<Cards>(context, listen: false)
                        .loadMyCards(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: client.myCards.length,
                          itemBuilder: (context, index) {
                            final BankCard card =
                                client.myCards.elementAt(index);

                            return ListTile(
                              key: ObjectKey(card.databaseID),
                              leading: const Icon(Icons.credit_card),
                              title: Text(card.cardholderName),
                              subtitle: Text("**** ${card.numberLastDigits}"),
                              onTap: () =>
                                  _showCardInfo(card, CardType.createdCards),
                            );
                          },
                        ),
                      );
                    },
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
