import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/models/auth.dart';
import 'package:spacepay/util/validators.dart';
import 'package:spacepay/views/components.dart/account_type_dropdown.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/users.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _formIsValid = false;
  final Map<String, String> _formData = {};
  final _passwordController = TextEditingController();

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  void _signUp() async {
    try {
      Auth.signUp(_formData['email']!, _formData['password']!);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
      return;
    }
  }

  void _submit() {
    _formIsValid = _formKey.currentState?.validate() ?? false;
    if (!_formIsValid) return;

    _formKey.currentState?.save();

    final provider = Provider.of<Users>(context, listen: false);

    _signUp();

    provider.addClient(clientData: _formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Inscreva-se",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 46,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (newname) {
                            _formData['fullName'] = newname ?? "";
                          },
                          validator: Validator.mandatoryFieldValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _formData['email'] = newValue ?? "";
                          },
                          validator: Validator.emailValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: Validator.cpf,
                          onSaved: (newValue) {
                            _formData['cpf'] = newValue ?? "";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: Validator.mandatoryFieldValidator,
                          onSaved: (newValue) {
                            _formData['phone'] = newValue ?? "";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Endereço',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: Validator.mandatoryFieldValidator,
                          onSaved: (newValue) {
                            _formData['address'] = newValue ?? "";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: Validator.alfaNumericValidator,
                          controller: _passwordController,
                          onSaved: (newValue) {
                            _formData['password'] = newValue ?? "";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Senha',
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (newPassword) {
                            bool isEqual =
                                newPassword == _passwordController.text;
                            if (!isEqual) {
                              return "As senhas não coincidem";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AccountTypeDropDown(formData: _formData),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                //TODO
                onPressed: () {
                  _submit();
                },
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
