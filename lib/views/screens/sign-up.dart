import 'package:banksys/views/components.dart/account_type.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isADM = false;
  final List<String> upperTextList = ["Sou ADM", "Sou cliente"];
  String upperText = "Sou ADM";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _isADM = !_isADM;
                      _isADM
                          ? upperText = upperTextList[1]
                          : upperText = upperTextList[0];
                    });
                  },
                  child: Text(upperText)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: size.height * 0.6,
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        if (!_isADM)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                        ),
                        if (!_isADM)
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter(),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                          ),
                        if (_isADM)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Estado',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Endereço',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Senha',
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        if (!_isADM) const AccountTypeDropDown(),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                //TODO
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size((size.width * .8), (size.height * .05)),
                ),
                child: const Text("CONCLUIR"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem uma conta?",
                    style: theme.textTheme.headline6,
                  ),
                  TextButton(
                    //TODO
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "LOGIN",
                      style: theme.textTheme.button,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
