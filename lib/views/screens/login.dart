import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/models/exceptions/user_not_found_expection.dart';
import 'package:spacepay/models/auth.dart';
import 'package:spacepay/models/user.dart';
import 'package:spacepay/util/routes.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spacepay/views/screens/reset_password.dart';

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
  bool _showPassword = false;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {Auth.password: '', UserAttributes.cpf: ''};

  Future<void> _authenticate() async {
    final auth = Provider.of<Auth>(context, listen: false);

    try {
      await auth.authenticate(
          _authData[UserAttributes.cpf]!, _authData[Auth.password]!, _isADM);
    } on UserNotFoundException catch (error) {
      _showErrorDialog(error.toString());
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
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

    final auth = Provider.of<Auth>(context, listen: false);

    _authenticate().then((value) {
      if (auth.isClientAuth) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      }

      if (auth.isAdminAuthenticated) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.DASHBOARD);
      }
    });
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
                "assets/images/spacepay_transparent.png",
                scale: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "SpacePay",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
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
                        initialValue: "000.000.000-00",
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
                        // onFieldSubmitted: ((value) =>
                        //     FocusScope.of(context).requestFocus(_passwordFocus)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          initialValue: "Admin",
                          obscuringCharacter: '*',
                          obscureText: _showPassword,
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
                                  _showPassword = !_showPassword;
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
                          //TODO
                          onPressed: () {
                            _submit();
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
      ),
    );
  }
}
