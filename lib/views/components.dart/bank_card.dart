import 'package:flutter/material.dart';

class BankCardItem extends StatelessWidget {
  final double height;
  final double width;
  final String cardholderName;
  final String number;
  final String expireDate;
  final String cvc;
  final String cardFlagImage;
  final double imageScale;

  const BankCardItem({
    required this.height,
    required this.width,
    required this.cardFlagImage,
    required this.cardholderName,
    required this.number,
    required this.expireDate,
    required this.imageScale,
    required this.cvc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(15),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  cardholderName.toUpperCase(),
                  style: theme.textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 67, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      number.toUpperCase(),
                      style: theme.textTheme.headline6,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 67),
                child: Row(
                  children: [
                    if (expireDate.isNotEmpty)
                      Text(
                        "Validade: $expireDate",
                        style: theme.textTheme.headline6,
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
              style: theme.textTheme.headline6,
            ),
          ),
          if (cardFlagImage.isNotEmpty)
            Positioned(
              right: 15,
              bottom: 15,
              child: Image.asset(cardFlagImage, scale: imageScale),
            ),
        ],
      ),
    );
  }
}
