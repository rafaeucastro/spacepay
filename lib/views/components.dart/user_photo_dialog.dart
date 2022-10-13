import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/auth.dart';

class UserPhotoDialog extends StatelessWidget {
  const UserPhotoDialog({
    Key? key,
    required File? storedImage,
    required this.auth,
  })  : _storedImage = storedImage,
        super(key: key);

  final File? _storedImage;
  final Auth auth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<Auth>(context, listen: false);

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
                  icon: Icon(Icons.clear, color: theme.colorScheme.onSecondary),
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
  }
}
