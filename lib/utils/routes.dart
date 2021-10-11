import 'package:flutter/widgets.dart';
import 'package:irza/screens/auth/signin_screen.dart';
import 'package:irza/screens/category/category_screen.dart';
import 'package:irza/screens/home/home_screen.dart';
import 'package:irza/screens/home/screens/transaction/form/transaction_form_screen.dart';
import 'package:irza/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  CategoryScreen.routeName: (context) => const CategoryScreen(),
  // TransactionFormScreen.routeName: (context) => const TransactionFormScreen(),
};
