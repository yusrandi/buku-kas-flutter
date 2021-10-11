import 'package:flutter/material.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/screens/auth/signin_body.dart';

class SignInScreen extends StatelessWidget {
  final UserBloc bloc;
  SignInScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Please Welcome",
              style: TextStyle(color: Colors.white))),
      body: SignInBody(bloc: bloc),
    );
  }
}
