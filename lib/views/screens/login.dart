import 'package:banksys/util/routes.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _passwordFocus = FocusNode();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: Colors.blue.shade300,
              size: 45.0,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "SpacePay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'CPF',
                        border: UnderlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: ((value) =>
                          FocusScope.of(context).requestFocus(_passwordFocus)),
                    ),
                    TextFormField(
                      obscuringCharacter: '*',
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        labelText: 'Senha',
                        border: UnderlineInputBorder(),
                      ),
                      focusNode: _passwordFocus,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          //TODO
                          onPressed: () {},
                          child: Text(
                            "Esqueceu a senha?",
                            style: theme.textTheme.button,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      //TODO
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.DASHBOARD);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size((size.width * .8), (size.height * .05)),
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
