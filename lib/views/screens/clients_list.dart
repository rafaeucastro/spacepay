import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/users.dart';
import '../components.dart/client_info_bottom_sheet.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({super.key});

  void _clientInfo(Client client, BuildContext context) {
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
    final users = Provider.of<Users>(context);

    return RefreshIndicator(
      onRefresh: () => Provider.of<Users>(context, listen: false).loadClients(),
      child: Column(
        children: [
          const Text("Clientes"),
          Expanded(
            child: ListView.builder(
              itemCount: users.getClients.length,
              itemBuilder: (context, index) {
                final user = users.getClients.elementAt(index);

                return ListTile(
                  leading: user.profilePicture != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(
                            user.profilePicture!,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimary,
                        ),
                  title: Text(user.fullName),
                  subtitle: Text(user.email),
                  onTap: () => _clientInfo(user, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
