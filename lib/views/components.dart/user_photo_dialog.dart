import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/users.dart';

class UserPhotoDialog extends StatelessWidget {
  const UserPhotoDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final client = Provider.of<Users>(context).currentClient!;

    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: Container(
        height: size.height * 0.4,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(client.profilePicture!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
