import 'package:banksys/views/components.dart/card_type.dart';
import 'package:flutter/material.dart';

class AddExistingCard extends StatefulWidget {
  const AddExistingCard({Key? key}) : super(key: key);

  @override
  State<AddExistingCard> createState() => _AddExistingCardState();
}

class _AddExistingCardState extends State<AddExistingCard> {
  final String dica =
      "Dica: você pode encontrar essas informações na frente ou no verso do seu cartão físico."
      "Caso seja um cartão virtal, consulte os dados no aplicativo do seu banco";
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cVcController = TextEditingController();

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Análise"),
          content: const Text("Estamos analisando os seus dados. "
              "Em breve lhe confimaremos se a solicitação foi aceita ou não."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Ok")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Adicionar cartão existente"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size.height * 0.38,
                padding: const EdgeInsets.all(15),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Número do cartão',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: _cardNumberController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nome completo do titular',
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.45,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Validade',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: _expiryDateController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.45,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'CVC',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: _cVcController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const CardTypeDropDown(),
                      Text(
                        dica,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                height: size.height * 0.28,
                width: size.width,
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
                            _cardNumberController.text,
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 58, bottom: 10),
                          child: Row(
                            children: [
                              Text(_nameController.text.toUpperCase()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 58),
                          child: Row(
                            children: [
                              if (_expiryDateController.text.isNotEmpty)
                                Text(
                                  "Validade: ${_expiryDateController.text}",
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 15,
                      bottom: 15,
                      child: Text(_cVcController.text),
                    ),
                    const Positioned(
                      right: 15,
                      bottom: 15,
                      child: Icon(Icons.masks),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.height * 0.4, size.height * 0.05),
                  ),
                  child: const Text("Concluir"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
