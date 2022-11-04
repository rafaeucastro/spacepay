import 'package:spacepay/models/user.dart';
import 'package:flutter/material.dart';

class ClientInfo extends StatelessWidget {
  final Client client;
  final BuildContext context;
  const ClientInfo(this.client, this.context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.45,
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dados do cliente",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textScale * 20,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("CPF"),
              Text(
                client.cpf,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Endereço"),
              Text(
                client.address,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Telefone"),
              Text(
                client.phone.toString(),
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tipo de conta"),
              Text(
                client.accountType,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 40),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
