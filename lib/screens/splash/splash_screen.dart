import 'package:flutter/material.dart';
import 'package:irza/screens/splash/body.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }
}