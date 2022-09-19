import 'package:banksys/util/routes.dart';
import 'package:banksys/util/views/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SpacePay());

class SpacePay extends StatelessWidget {
  const SpacePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Space Pay",
      home: const SplashScreen(),
      routes: {
        AppRoutes.LOGIN: (context) => const Login(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252626),
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
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
