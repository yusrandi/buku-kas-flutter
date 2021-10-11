import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irza/blocs/category_bloc/category_bloc.dart';
import 'package:irza/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:irza/blocs/user_category_bloc/user_category_bloc.dart';
import 'package:irza/models/transaction_model.dart';
import 'package:irza/repositories/category_repo.dart';
import 'package:irza/repositories/transaction_repo.dart';
import 'package:irza/repositories/user_category_repo.dart';
import 'package:irza/screens/home/screens/transaction/form/transaction_form_body.dart';

class TransactionFormScreen extends StatefulWidget {
  static String routeName = "/Transactionform";
  final Transaction tr;
  const TransactionFormScreen({Key? key, required this.tr}) : super(key: key);

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Form Transaksi"),
          centerTitle: false,
        ),
        body: BlocProvider(
          create: (context) => TransactionBloc(TransactionRepoImpl()),
          child: BlocProvider(
            create: (context) => UserCategoryBloc(UserCategoryRepositoryImpl()),
            child: TransactionFormBody(tr: widget.tr),
          ),
        ));
  }
}
