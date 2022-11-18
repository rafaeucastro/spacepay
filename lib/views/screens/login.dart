import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacepay/models/auth_service.dart';
import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/util/routes.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacepay/util/utils.dart';
import 'package:spacepay/views/screens/reset_password.dart';

import '../../util/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _formIsValid = false;
  bool _isADM = false;
  bool _hidePassword = true;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    UserAttributes.cpf: '',
    UserAttributes.password: '',
  };

  Future<void> _logIn() async {
    try {
      await AuthFirebaseService().signIn(_authData[UserAttributes.cpf]!,
          _authData[UserAttributes.password]!, _isADM);
    } on FirebaseAuthException catch (error) {
      Utils.showSnackBar(error.toString(), context);
      return;
    } on AuthException catch (error) {
      Utils.showSnackBar(error.toString(), context);
      return;
    }

    String initialScreen = _isADM ? AppRoutes.DASHBOARD : AppRoutes.HOME;

    Navigator.of(context).pushReplacementNamed(initialScreen);
  }

  void _submit() {
    _formIsValid = _formKey.currentState?.validate() ?? false;

    if (!_formIsValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    _logIn();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo2.png",
                scale: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "SpacePay",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 32,
                    fontFamily: 'Eczar',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        //initialValue: "000.000.000-00",
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: 'CPF',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter()
                        ],
                        validator: (value) {
                          final cpf = value ?? "";
                          if (cpf.isEmpty) {
                            return "Digite seu CPF!";
                          }
                          return null;
                        },
                        onSaved: (cpf) {
                          _authData['cpf'] = cpf!;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          //initialValue: "Rafael123\$\$",
                          //initialValue: 'Admin',
                          obscuringCharacter: '*',
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.key,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.password,
                                color: theme.colorScheme.secondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                            ),
                            labelText: 'Senha',
                            border: const OutlineInputBorder(),
                          ),
                          focusNode: _passwordFocus,
                          validator: (value) {
                            final password = value ?? "";
                            if (password.isEmpty) {
                              return "Digite sua senha!";
                            }
                            return null;
                          },
                          onSaved: (password) {
                            _authData['password'] = password!;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isADM,
                                onChanged: (value) {
                                  setState(() {
                                    _isADM = value ?? false;
                                  });
                                },
                              ),
                              const Text("Sou admin"),
                            ],
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResetPassword(),
                            )),
                            child: Text(
                              "Esqueceu a senha?",
                              style: theme.textTheme.button,
                            ),
                          ),
                        ],
                      ),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () => _submit(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              (size.width * .8),
                              (size.height * .05),
                            ),
                          ),
                          child: const Text("ENTRAR"),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Não tem uma conta?",
                    style: theme.textTheme.headline6,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.SIGN_UP);
                    },
                    child: Text(
                      "INSCREVA-SE",
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
