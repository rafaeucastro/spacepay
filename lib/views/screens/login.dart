import 'package:banksys/exceptions/auth_exception.dart';
import 'package:banksys/exceptions/user_not_found_expection.dart';
import 'package:banksys/models/auth.dart';
import 'package:banksys/models/user.dart';
import 'package:banksys/util/routes.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';

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
  // ignore: prefer_final_fields
  Map<String, String> _authData = {Auth.password: '', UserAttributes.cpf: ''};

  void _submit() async {
    _formIsValid = _formKey.currentState?.validate() ?? false;

    if (!_formIsValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    final auth = Provider.of<Auth>(context, listen: false);

    if (_isADM) {
      // await auth.signUp("castrorafael456@gmail.com", "faelzin");
    } else {
      try {
        await auth.authenticate(_authData[UserAttributes.cpf]!,
            _authData[Auth.password]!, AuthMode.signIn);
      } on UserNotFoundException catch (error) {
        _showErrorDialog(error.toString());
      } on AuthException catch (error) {
        _showErrorDialog(error.toString());
      }
    }

    auth.isAuth ? print('authenticated') : print('not');
  }

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
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
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: theme.colorScheme.primary,
              size: 45.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                "SpacePay",
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 32,
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: theme.colorScheme.onSecondary,
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
                      // onFieldSubmitted: ((value) =>
                      //     FocusScope.of(context).requestFocus(_passwordFocus)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: TextFormField(
                        obscuringCharacter: '*',
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.key,
                            color: theme.colorScheme.onSecondary,
                          ),
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          //TODO
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.DASHBOARD);
                          },
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
                        //TODO
                        onPressed: () {
                          _submit();
                          if (_formIsValid) {
                            auth.isAuth
                                ? Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.DASHBOARD)
                                : null;
                            setState(
                              () => _isLoading = false,
                            );
                          }
                        },
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
                  //TODO
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
    );
  }
}
