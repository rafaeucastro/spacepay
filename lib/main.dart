import 'package:banksys/util/routes.dart';
import 'package:banksys/views/add_existing_card.dart';
import 'package:banksys/views/home.dart';
import 'package:banksys/views/login.dart';
import 'package:banksys/views/sign-up.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SpacePay());

class SpacePay extends StatelessWidget {
  const SpacePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.dark();
    final Color primary = Colors.blue.shade300;
    final Color onPrimary = Colors.blue.shade900;
    const Color secondary = Colors.white;
    const Color onSecondary = Colors.white70;

    return MaterialApp(
      theme: theme.copyWith(
        inputDecorationTheme: const InputDecorationTheme().copyWith(
          border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(10),
          // constraints: const BoxConstraints(maxHeight: 40, maxWidth: 300),
          // fillColor: theme.colorScheme.onSecondary,
          // filled: true,
        ),
        colorScheme: theme.colorScheme.copyWith(
          background: const Color(0xff252626),
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
        ),
        textTheme: theme.textTheme.copyWith(
          button: TextStyle(
            color: primary,
          ),
          headline6: const TextStyle(
            color: onSecondary,
            fontSize: 15.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: onPrimary,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )),
      ),
      title: "Space Pay",
      home: const SplashScreen(),
      routes: {
        AppRoutes.LOGIN: (context) => const Login(),
        AppRoutes.SIGN_UP: (context) => const SignUp(),
        AppRoutes.DASHBOARD: (context) => const DashBoard(),
        AppRoutes.ADD_EXISTING_CARD: (context) => const AddExistingCard(),
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
