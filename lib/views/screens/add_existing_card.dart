import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:spacepay/models/card.dart';
import 'package:spacepay/providers/cards.dart';
import 'package:spacepay/util/validators.dart';
import 'package:spacepay/views/components.dart/bank_card.dart';
import 'package:spacepay/views/components.dart/card_flag_dropdown.dart';

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
  final _cvcController = TextEditingController();

  // ignore: prefer_final_fields
  Map<String, String> _formData = {
    CardAttributes.flag: "Visa",
  };
  final _formKey = GlobalKey<FormState>();
  bool _formIsValid = false;
  //TODO: trocar por uma lista no tipo CardFlag
  final List<String> _cardFlag = [
    "Elo",
    "Visa",
    "HiperCard",
    "MasterCard",
    "AmericanExpress"
  ];

  // ignore: prefer_final_fields
  String _dropdownValue = "Erro";
  String _cardFlagImage = "";
  double _imageScale = 4.0;

  void _submit() {
    _formIsValid = _formKey.currentState?.validate() ?? false;
    if (!_formIsValid) {
      return;
    }

    _formKey.currentState?.save();

    final cards = Provider.of<Cards>(context, listen: false);
    cards.addCard(_formData, context);
    _showDialog();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          elevation: 10,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            "CADASTRAR CARTÃO",
            style: theme.textTheme.titleMedium,
          ),
          content: Text(
            "Seu cartão foi cadastrado com sucesso!",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: theme.textTheme.titleMedium,
                )),
          ],
        );
      },
    );
  }

  void _switchImage(Object? object) {
    final result = CardFlag.switchFlagImage(
      identification: object.toString(),
      flagImage: _cardFlagImage,
      imageScale: _imageScale,
    );
    _cardFlagImage = result.keys.first;
    _imageScale = result.values.first;
    setState(() {
      _formData[CardAttributes.flag] = object.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Adicionar cartão existente"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size.height * 0.45,
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CartaoBancarioInputFormatter(),
                        ],
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (newValue) {
                          _formData[CardAttributes.number] = newValue!;
                        },
                        validator: Validator.cardNumber,
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
                        onSaved: (newValue) {
                          _formData[CardAttributes.cardholderName] = newValue!;
                        },
                        validator: Validator.mandatoryFieldValidator,
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ValidadeCartaoInputFormatter(),
                              ],
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (newValue) {
                                _formData[CardAttributes.expiryDate] =
                                    newValue!;
                              },
                              validator: Validator.cardExpiryDate,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.45,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'CVC',
                                counterText: "",
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: _cvcController,
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (newValue) {
                                _formData[CardAttributes.cvc] = newValue!;
                              },
                              validator: Validator.cardCVC,
                            ),
                          ),
                        ],
                      ),
                      CardFlagDropDown(
                        cardFlag: _cardFlag,
                        dropdownValue:
                            _formData[CardAttributes.flag] ?? _dropdownValue,
                        onChanged: (object) => _switchImage(object),
                      ),
                      Text(
                        dica,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              BankCardItem(
                height: size.height * 0.28,
                width: size.width,
                cardFlagImage: _cardFlagImage,
                cardholderName: _nameController.text,
                number: _cardNumberController.text,
                expireDate: _expiryDateController.text,
                imageScale: _imageScale,
                cvc: _cvcController.text,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _submit();
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
