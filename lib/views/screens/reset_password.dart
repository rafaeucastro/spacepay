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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

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
      appBar: AppBar(
        title: const Text("Redefinir senha"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Seu E-mail',
              border: OutlineInputBorder(),
              helperText:
                  "Enviaremos um link de redefinição de senha para esse e-mail",
            ),
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.emailAddress,
            validator: Validator.emailValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailController,
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
