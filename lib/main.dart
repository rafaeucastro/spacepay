import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spacepay/providers/cards.dart';
import 'package:spacepay/providers/users.dart';
import 'package:spacepay/providers/cards_requests.dart';

import 'package:spacepay/views/screens/dashboard.dart';
import 'package:spacepay/views/screens/my_requests.dart';
import 'package:spacepay/views/screens/add_existing_card.dart';
import 'package:spacepay/views/screens/home.dart';
import 'package:spacepay/views/screens/login.dart';
import 'package:spacepay/views/screens/sign-up.dart';
import 'package:spacepay/views/screens/splash_screen.dart';
import 'package:spacepay/views/screens/user_profile.dart';

import 'package:spacepay/util/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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
        ChangeNotifierProvider<Users>(
          create: (context) => Users(),
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
              color: onPrimary,
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
