import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:irza/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:irza/models/transaction_model.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'form/transaction_form_screen.dart';

class TransactionBody extends StatefulWidget {
  const TransactionBody({Key? key}) : super(key: key);

  @override
  _TransactionBodyState createState() => _TransactionBodyState();
}

class _TransactionBodyState extends State<TransactionBody> {
  late SharedPreferences sharedpref;
  late TransactionBloc transactionBloc;

  @override
  void initState() {
    super.initState();
    transactionBloc = BlocProvider.of<TransactionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    getUser();

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (BuildContext context, state) {
        print(state);
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionInitialState ||
              state is TransactionLoadingState) {
            return buildLoading();
          } else if (state is TransactionLoadedState) {
            List<Transaction> list = state.model.transaction;
            return buildBody(list);
          } else {
            return buildLoading();
          }
        },
      ),
    );
  }

  Stack buildBody(List<Transaction> list) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              transTop(listTransaction: list),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text('Detail Transaksi',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: getProportionateScreenHeight(8)),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Transaction tr = list[index];

                        return transactionCard(tr);
                      })),
            ],
          ),
        ),
        Positioned(
            right: 8,
            bottom: 8,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionFormScreen(
                                tr: Transaction(
                                    id: 0,
                                    categoryId: 0,
                                    userId: 0,
                                    title: "title",
                                    date: "date",
                                    nominal: "nominal",
                                    notes: "notes",
                                    status: "status"))))
                    .then((value) => setState(() {}));
              },
              child: const Icon(FontAwesomeIcons.plus),
              backgroundColor: kSecondaryColor,
            )),
      ],
    );
  }

  GestureDetector transactionCard(Transaction tr) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionFormScreen(tr: tr)))
            .then((value) => setState(() {}));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr.title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(tr.date,
                        style:
                            const TextStyle(color: kTextColor, fontSize: 14)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format((int.parse(tr.nominal)))
                                .toString(),
                        style: TextStyle(
                            color: tr.status == "1" ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(tr.category!.name,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ],
            ),
            const Divider(
              color: kTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void getUser() async {
    sharedpref = await SharedPreferences.getInstance();
    var userId = sharedpref.get("id");
    print("getUser $userId");

    transactionBloc.add(TransactionFetchDataEvent(userId.toString()));
  }
}

class transTop extends StatelessWidget {
  const transTop({
    Key? key,
    required this.listTransaction,
  }) : super(key: key);

  final List<Transaction> listTransaction;

  @override
  Widget build(BuildContext context) {
    var sumMasuk = 0;
    var sumKeluar = 0;
    listTransaction.forEach((element) {
      if (element.status == "1") {
        sumMasuk += int.parse(element.nominal);
      } else {
        sumKeluar += int.parse(element.nominal);
      }
    });
    return Container(
      height: 100,
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Pemasukan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(
                    "Rp. " +
                        NumberFormat("#,##0", "en_US")
                            .format((sumMasuk))
                            .toString(),
                    style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Pengeluaran',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(
                    "Rp. " +
                        NumberFormat("#,##0", "en_US")
                            .format((sumKeluar))
                            .toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
