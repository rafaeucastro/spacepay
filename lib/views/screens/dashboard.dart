// ignore_for_file: unused_local_variable

import 'package:banksys/models/user.dart';
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
  void _clientInfo(Client client) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClientInfo(client, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final users = Provider.of<Users>(context);

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
            Container(),
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
          ],
        ),
      ),
    );
  }
}
