import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/screens/auth/signin_screen.dart';
import 'package:irza/screens/home/home_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late UserBloc bloc;

  @override
  void initState() {
    super.initState();

    print("initState");
    bloc = BlocProvider.of<UserBloc>(context);
    bloc.add(UserCheckLoginEvent());

    // loginAction();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print(state);
        loginAction(state);
      },
      child: const Center(
        child: Text(
          'Welcome To Our App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void loginAction(UserState state) async {
    await new Future.delayed(const Duration(seconds: 2));

    if (state is UserLoggedOutState) {
      gotoAnotherPage(SignInScreen(bloc: bloc));
    } else if (state is UserLoggedInState) {
      gotoAnotherPage(HomeScreen(bloc: bloc));
    }
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
