import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spacepay/models/exceptions/auth_exception.dart';
import 'package:spacepay/util/utils.dart';
import '../../util/validators.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();

  void _resetPassword() async {
    if (_emailController.text.isEmpty) return;

    Utils.showLoadingDialog(context);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
    } on FirebaseAuthException catch (error) {
      Utils.showSnackBar(AuthException.translateException(error.code), context);
      Navigator.of(context).pop();
      return;
    }

    _goToLoginScreen();
  }

  void _goToLoginScreen() {
    Utils.showSnackBar(
        "Link enviado! Siga os passos indicados no seu e-mail e faça login com a nova senha.",
        context);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Redefinir senha"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/forgot_password.png',
            scale: 3,
          ),
          const Text("Ops, parece que alguém esqueceu a senha!"),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Seu E-mail',
                border: const OutlineInputBorder(),
                helperText:
                    "Enviaremos um link de redefinição de senha para esse e-mail",
                helperStyle: Theme.of(context).textTheme.bodySmall,
              ),
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.emailValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _resetPassword,
            icon: const Icon(Icons.outgoing_mail),
            label: const Text("Enviar"),
          ),
        ],
      )),
    );
  }
}
