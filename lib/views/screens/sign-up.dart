// ignore: file_names
import 'package:animations/animations.dart';
import 'package:http/http.dart';
import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/models/auth.dart';
import 'package:spacepay/util/utils.dart';
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
  int _step = 1;

  void _signUp() async {
    try {
      Auth.signUp(_formData['email']!, _formData['password']!);
    } on AuthException catch (error) {
      Utils.showSnackBar(error.toString(), context);
      return;
    }
  }

  void _next() {
    _formIsValid = _formKey.currentState?.validate() ?? false;
    if (!_formIsValid) return;

    _formKey.currentState?.save();

    setState(() {
      _step = 2;
    });
  }

  void _submit() {
    _formIsValid = _formKey.currentState?.validate() ?? false;
    if (!_formIsValid) return;

    _formKey.currentState?.save();

    final provider = Provider.of<Users>(context, listen: false);

    _signUp();

    provider.addClient(clientData: _formData);

    Navigator.of(context).pop();
    Utils.showSnackBar("Usuário criado com sucesso! Faça o login.", context);
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
            children: [
              SizedBox(
                height: size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.height * 0.2,
                      width: size.width * 0.75,
                      child: Image.asset(
                        'assets/images/sign-up-form.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "Inscreva-se",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 46,
                        fontFamily: 'Eczar',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 180),
                child: Form(
                  key: _formKey,
                  child: PageTransitionSwitcher(
                    duration: const Duration(seconds: 1),
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                    child: _step == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            key: const ValueKey('Primeiro'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                  key: const ValueKey('Nome Completo'),
                                  initialValue: _formData['fullName'],
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
                                  key: const ValueKey('E-mail'),
                                  initialValue: _formData['email'],
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
                                  key: const ValueKey('CPF'),
                                  initialValue: _formData['cpf'],
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
                                  key: const ValueKey('Telefone'),
                                  initialValue: _formData['phone'],
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
                              ElevatedButton(
                                onPressed: _next,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      (size.width * .3), (size.height * .05)),
                                ),
                                child: const Text("Avançar"),
                              ),
                            ],
                          )
                        : Column(
                            key: const ValueKey('Segundo'),
                            children: [
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _step = 1;
                                      });
                                    },
                                    child: Text(
                                      "Voltar",
                                      style: theme.textTheme.button,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size((size.width * .3),
                                          (size.height * .05)),
                                    ),
                                    child: const Text("Concluir"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem uma conta?",
                    style: theme.textTheme.headline6,
                  ),
                  TextButton(
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
