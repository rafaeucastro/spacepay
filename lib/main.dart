import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:banksys/models/auth.dart';
import 'package:banksys/models/cards.dart';
import 'package:banksys/models/users.dart';

import 'package:banksys/views/screens/add_existing_card.dart';
import 'package:banksys/views/screens/home.dart';
import 'package:banksys/views/screens/login.dart';
import 'package:banksys/views/screens/sign-up.dart';

import 'package:banksys/util/routes.dart';

void main() => runApp(const SpacePay());

class SpacePay extends StatelessWidget {
  const SpacePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.dark();
    final Color primary = Colors.blue.shade900;
    const Color onPrimary = Colors.white;
    const Color secondary = Colors.black;
    final Color onSecondary = Colors.blue.shade100;
    final tertiary = Colors.blue.shade200;
    const onTertiary = Colors.greenAccent;
    const Color background = Colors.black;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Users(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cards(),
        ),
      ],
      child: MaterialApp(
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
            background: background,
            primary: primary,
            onPrimary: onPrimary,
            secondary: secondary,
            onSecondary: onSecondary,
            tertiary: tertiary,
            onTertiary: onTertiary,
          ),
          textTheme: theme.textTheme.copyWith(
            button: TextStyle(
              color: onSecondary,
            ),
            headline5: TextStyle(
              color: primary,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: primary,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )),
          snackBarTheme: SnackBarThemeData().copyWith(
            backgroundColor: theme.colorScheme.primary,
            contentTextStyle: theme.textTheme.button,
          ),
        ),
        title: "Space Pay",
        home: const SplashScreen(),
        routes: {
          AppRoutes.LOGIN: (context) => const Login(),
          AppRoutes.SIGN_UP: (context) => const SignUp(),
          AppRoutes.DASHBOARD: (context) => const DashBoard(),
          AppRoutes.ADD_EXISTING_CARD: (context) => const AddExistingCard(),
        },
      ),
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
    await Provider.of<Users>(context, listen: false).loadData();

    Future.delayed(const Duration(seconds: 0)).then((value) {
      Provider.of<Auth>(context, listen: false).isAuth
          ? Navigator.of(context).pushReplacementNamed(AppRoutes.DASHBOARD)
          : Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: theme.colorScheme.primary,
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
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
