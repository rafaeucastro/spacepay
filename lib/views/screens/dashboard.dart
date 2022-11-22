// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'package:spacepay/providers/cards_requests.dart';
import 'package:spacepay/views/screens/clients_list.dart';
import 'package:spacepay/views/screens/requests.dart';

import '../../providers/users.dart';
import '../../util/routes.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _tabs = const [
    ClientsList(),
    ClientRequests(),
  ];
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<BankCardRequests>(context, listen: false).loadRequests(context);
    Provider.of<Users>(context, listen: false).loadClients();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final users = Provider.of<Users>(context);
    final newCardRequests = Provider.of<BankCardRequests>(context).cardRequests;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.background,
        title: const Center(child: Text("Dashboard")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: colorScheme.background,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: PageTransitionSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: _tabs[_currentTabIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorScheme.background,
        currentIndex: _currentTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Clientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: "Solicitações",
          ),
        ],
        onTap: (value) => setState(() {
          _currentTabIndex = value;
        }),
      ),
    );
  }
}
