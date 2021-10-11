import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/repositories/user_repo.dart';
import 'package:irza/screens/home/screens/user/user_screen_body.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(UserRepositoryImpl()),
      child: const UserScreenBody(),
    );
  }
}
