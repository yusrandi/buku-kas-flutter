import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irza/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:irza/repositories/transaction_repo.dart';
import 'package:irza/screens/home/screens/transaction/form/transaction_form_screen.dart';
import 'package:irza/screens/home/screens/transaction/transaction_body.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late List<TransactionModel> listTransaction;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(TransactionRepoImpl()),
      child: const TransactionBody(),
    );
  }
}

class TransactionModel {
  final String title;
  final String date;
  final String nominal;
  final String category;
  final int status;

  TransactionModel(
      this.title, this.date, this.nominal, this.category, this.status);
}
