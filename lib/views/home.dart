import 'package:banksys/util/routes.dart';
import 'package:banksys/views/components.dart/new_card_form.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const NewCardForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("SpacePay")),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showModal();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.onSecondary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_card),
                          Text("Criar cartão"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.ADD_EXISTING_CARD);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.onSecondary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_card),
                          Text("Cadastrar novo cartão"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.onSecondary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.credit_card),
                          Text("Meus cartões"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //SizedBox(
          //   height: size.height * 0.1,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Card(
          //           elevation: 5,
          //           color: theme.colorScheme.onSecondary,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.add_card),
          //               Text("Criar cartão"),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Card(
          //           elevation: 5,
          //           color: theme.colorScheme.onSecondary,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.add_card),
          //               Text("Cadastrar novo cartão"),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Card(
          //           elevation: 5,
          //           color: theme.colorScheme.onSecondary,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.credit_card),
          //               Text("Seus cartões"),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
