import 'package:flutter/material.dart';

import '../../models/card.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Image.asset(CardFlag.eloImage),
          onPressed: () {},
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
      body: Center(
          child: Column(
        children: [
          Container(
            color: Colors.red,
          ),
        ],
      )),
    );
  }
}
