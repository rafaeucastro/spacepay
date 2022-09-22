import 'package:banksys/models/card.dart';
import 'package:banksys/models/cards.dart';
import 'package:banksys/util/validators.dart';
import 'package:banksys/views/components.dart/card_flag_dropdown.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    cards.addExistingCard(_formData);
    _showDialog();
  }

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
                              controller: _cVcController,
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
                          padding: const EdgeInsets.only(left: 67, bottom: 10),
                          child: Row(
                            children: [
                              Text(_nameController.text.toUpperCase()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 67),
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
                    if (_cardFlagImage.isNotEmpty)
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: Image.asset(_cardFlagImage, scale: _imageScale),
                      ),
                  ],
                ),
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
