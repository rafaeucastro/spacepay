import 'package:flutter/material.dart';

class BankCardItem extends StatelessWidget {
  final double height;
  final double width;
  final String cardholderName;
  final String number;
  final String expireDate;
  final String cvc;
  final String cardFlagImage;

  const BankCardItem({
    required this.height,
    required this.width,
    required this.cardFlagImage,
    required this.cardholderName,
    required this.number,
    required this.expireDate,
    required this.cvc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(15),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.red,
            theme.colorScheme.primary,
            theme.colorScheme.primary,
            theme.colorScheme.primary,
            theme.colorScheme.onPrimary,
            theme.colorScheme.onPrimary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 10),
                child: Text(
                  cardholderName.toUpperCase(),
                  style: theme.textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      number.toUpperCase(),
                      style: theme.textTheme.headline5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    if (expireDate.isNotEmpty)
                      Text(
                        "Validade: $expireDate",
                        style: theme.textTheme.headline5,
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: Text(
              cvc,
              style: theme.textTheme.headline5,
            ),
          ),
          if (cardFlagImage.isNotEmpty)
            Positioned(
              right: 15,
              bottom: 5,
              child: Image.asset(cardFlagImage, scale: 15),
            ),
        ],
      ),
    );
  }
}
