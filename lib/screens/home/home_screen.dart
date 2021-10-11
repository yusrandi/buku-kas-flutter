import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/screens/category/category_screen.dart';
import 'package:irza/screens/home/screens/cart/cart_screen.dart';
import 'package:irza/screens/home/screens/transaction/transaction_screen.dart';
import 'package:irza/screens/home/screens/user/user_screen.dart';
import 'package:irza/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  final UserBloc bloc;

  const HomeScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const CartScreen(),
    const TransactionScreen(),
    const UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Irza App',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              onSelected: handleClick,
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home),
                label: 'Home',
                backgroundColor: kPrimaryColor),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.cartArrowDown),
                label: 'transaction',
                backgroundColor: kPrimaryColor),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: 'User',
                backgroundColor: kPrimaryColor),
          ]),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        Navigator.pushNamed(context, CategoryScreen.routeName);
        break;
    }
  }
}
