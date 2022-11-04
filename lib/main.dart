import 'package:spacepay/providers/cards_requests.dart';
import 'package:spacepay/views/screens/card_requests.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:spacepay/views/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spacepay/models/auth.dart';
import 'package:spacepay/providers/cards.dart';
import 'package:spacepay/providers/users.dart';

import 'package:spacepay/views/screens/add_existing_card.dart';
import 'package:spacepay/views/screens/home.dart';
import 'package:spacepay/views/screens/login.dart';
import 'package:spacepay/views/screens/sign-up.dart';

import 'package:spacepay/util/routes.dart';
import 'package:spacepay/views/screens/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const SpacePay());
}

class SpacePay extends StatelessWidget {
  const SpacePay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.dark();
    const Color primary = Color(0xFFFF5249);
    const Color onPrimary = Colors.white;
    const Color secondary = Color(0xFFFFDD78);
    const Color onSecondary = Colors.black;
    final tertiary = Colors.blue.shade900;
    const onTertiary = Colors.amber;
    const Color background = Colors.black;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (context) => Users(null, []),
          update: (context, auth, previous) {
            return Users(
              auth.client,
              previous!.getClients,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Cards(),
        ),
        ChangeNotifierProvider(
          create: (context) => BankCardRequests(),
        ),
      ],
      child: MaterialApp(
        theme: theme.copyWith(
          canvasColor: Colors.transparent,
          inputDecorationTheme: const InputDecorationTheme().copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: const EdgeInsets.all(10),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondary),
            ),
            labelStyle: const TextStyle(
              color: secondary,
            ),
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
            button: const TextStyle(
              color: onTertiary,
            ),
            headline5: const TextStyle(
              color: onPrimary,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            headline6: const TextStyle(
              color: primary,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
            subtitle2: const TextStyle(
              color: onPrimary,
              fontSize: 15.0,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: onTertiary,
            foregroundColor: onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )),
          snackBarTheme: const SnackBarThemeData().copyWith(
            backgroundColor: primary,
            contentTextStyle: theme.textTheme.button,
          ),
          iconTheme: const IconThemeData().copyWith(
            color: secondary,
          ),
          checkboxTheme: const CheckboxThemeData().copyWith(
            fillColor: MaterialStateProperty.all(primary),
          ),
        ),
        title: "Space Pay",
        home: const SplashScreen(),
        routes: {
          AppRoutes.LOGIN: (context) => const Login(),
          AppRoutes.SIGN_UP: (context) => const SignUp(),
          AppRoutes.DASHBOARD: (context) => const DashBoard(),
          AppRoutes.HOME: (context) => const Home(),
          AppRoutes.USER_PROFILE: (context) => const UserProfile(),
          AppRoutes.ADD_EXISTING_CARD: (context) => const AddExistingCard(),
          AppRoutes.CARD_REQUESTS: (context) => const MyCardRequests(),
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
    await Provider.of<Users>(context, listen: false).loadClients();
    await Provider.of<Users>(context, listen: false).loadAdmins();

    Future.delayed(const Duration(seconds: 0)).then((value) {
      Provider.of<Auth>(context, listen: false).isClientAuth
          ? Navigator.of(context).pushReplacementNamed(AppRoutes.HOME)
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
