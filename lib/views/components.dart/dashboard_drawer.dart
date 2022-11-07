import 'package:flutter/material.dart';

class DashBoardDrawer extends StatelessWidget {
  const DashBoardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: colorScheme.background,
      child: Column(
        children: [
          AppBar(
            title: const Text("SpacePay"),
            backgroundColor: colorScheme.onTertiary,
          ),
          ListTile(
            title: const Text("Cadastrar Novo Cartão"),
            tileColor: colorScheme.primary,
          ),
          ListTile(
            title: const Text("Solicitações"),
            tileColor: colorScheme.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
