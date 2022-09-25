import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(15),
      height: size.height * 0.28,
      width: size.width,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: const [
          Text("eapp"),
        ],
      ),
    );
  }
}
