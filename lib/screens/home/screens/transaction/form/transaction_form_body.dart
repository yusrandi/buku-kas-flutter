import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:irza/blocs/category_bloc/category_bloc.dart';
import 'package:irza/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:irza/blocs/user_category_bloc/user_category_bloc.dart';
import 'package:irza/config/shared_info.dart';
import 'package:irza/helper/keyboard.dart';
import 'package:irza/models/category_model.dart';
import 'package:irza/models/transaction_model.dart';
import 'package:irza/models/user_category_model.dart';
import 'package:irza/screens/category/category_screen.dart';
import 'package:irza/screens/home/home_screen.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';
import 'package:irza/widgets/danger_button.dart';
import 'package:irza/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TransactionFormBody extends StatefulWidget {
  final Transaction tr;
  const TransactionFormBody({Key? key, required this.tr}) : super(key: key);

  @override
  _TransactionFormBodyState createState() => _TransactionFormBodyState();
}

class _TransactionFormBodyState extends State<TransactionFormBody> {
  bool isPemasukan = true;
  String rolePemasukan = "1";

  late DateTime initialDate;
  late TransactionBloc transactionBloc;
  late UserCategoryBloc userCategoryBloc;

  List<Usercategory> listCategory = [];
  List<Usercategory> listChoice = [];

  String resKategoriName = "Pilih Kategori (optional)";
  int resId = 0;
  int resKategoriId = 0;
  String resUserId = "";
  String resTgl = "";
  String resNote = "";
  String resStatus = "";

  late SharedPreferences sharedpref;

  final _formKey = GlobalKey<FormState>();
  final _tfNominal = TextEditingController();
  final _tfJudul = TextEditingController();
  final _tfCatatan = TextEditingController();

  String? validateValue(value) {
    if (value.isEmpty) {
      return kFieldRequiredError;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();

    initialDate = DateTime.now();
    resTgl = DateFormat('yyyy/MM/dd').format(initialDate);

    userCategoryBloc = BlocProvider.of<UserCategoryBloc>(context);
    transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (widget.tr.id != 0) {
      _tfJudul.text = widget.tr.title;
      _tfCatatan.text = widget.tr.notes;
      _tfNominal.text = widget.tr.nominal;
      resTgl = widget.tr.date;
      resId = widget.tr.id;
      resKategoriId = widget.tr.categoryId;
      resKategoriName = widget.tr.category!.name;
      rolePemasukan = widget.tr.status;
      if (widget.tr.status == "1") {
        isPemasukan = true;
      } else {
        isPemasukan = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        print(state);
        if (state is TransactionInitialState ||
            state is TransactionLoadingState) {
          EasyLoading.show(status: 'wait a second');
        } else if (state is TransactionErrorState) {
          EasyLoading.showError(state.msg);
          EasyLoading.dismiss();
        } else if (state is TransactionSuccessState) {
          EasyLoading.showSuccess(state.msg);
          EasyLoading.dismiss();
          Navigator.pop(context, true);
        }
      },
      child: BlocListener<UserCategoryBloc, UserCategoryState>(
        listener: (BuildContext context, state) {
          print(state);
          if (state is UserCategoryLoadedState) {
            listCategory.clear();
            listCategory.addAll(state.model.usercategory);

            if (listCategory.isEmpty) {
              Navigator.pushNamed(context, CategoryScreen.routeName);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              switchTogle(),
              SizedBox(height: getProportionateScreenHeight(16)),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 46),
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                pickDate(context);
                              },
                              child: tanggalField()),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          TextFormField(
                            controller: _tfJudul,
                            validator: validateValue,
                            keyboardType: TextInputType.text,
                            cursorColor: kSecondaryColor,
                            decoration: buildInputDecoration(
                                FontAwesomeIcons.desktop, "Judul Transaksi"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          TextFormField(
                            controller: _tfCatatan,
                            keyboardType: TextInputType.text,
                            cursorColor: kSecondaryColor,
                            decoration: buildInputDecoration(
                                FontAwesomeIcons.list,
                                "Catatan Detail (optional)"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          nominalField(),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          const Divider(color: Colors.black),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          const Text(
                            "Kategori Pilihan",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<bool>(
                                  builder: (BuildContext context) {
                                    listChoice = [];
                                    listChoice.addAll(listCategory.where((e) =>
                                        e.category!.role == rolePemasukan));
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: Text("Kategori"),
                                      ),
                                      body: WillPopScope(
                                        onWillPop: () async {
                                          Navigator.pop(context, false);
                                          return false;
                                        },
                                        child: listKategori(listChoice),
                                      ),
                                    );
                                  },
                                ));
                              },
                              child: kategoriField()),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        var judul = _tfJudul.text.trim();
                                        var nominal = _tfNominal.text.trim();
                                        var notes = _tfCatatan.text.trim();

                                        var tr = Transaction(
                                            id: resId,
                                            categoryId: resKategoriId,
                                            userId: int.parse(resUserId),
                                            title: judul,
                                            date: resTgl,
                                            nominal: nominal,
                                            notes:
                                                notes.isEmpty ? "empty" : notes,
                                            status: rolePemasukan);

                                        resId == 0
                                            ? transactionBloc
                                                .add(TransactionStoreEvent(tr))
                                            : transactionBloc.add(
                                                TransactionUpdateEvent(tr));
                                        EasyLoading.showSuccess(resUserId);
                                      }

                                      KeyboardUtil.hideKeyboard(context);
                                    },
                                    child: PrimaryButton(btnText: "Submit")),
                              ),
                              Visibility(
                                  visible: widget.tr.id != 0 ? true : false,
                                  child: const SizedBox(width: 16)),
                              Visibility(
                                visible: widget.tr.id != 0 ? true : false,
                                child: Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        transactionBloc.add(
                                            TransactionDeleteEvent(
                                                resId.toString()));
                                        KeyboardUtil.hideKeyboard(context);
                                      },
                                      child: DangerButton(btnText: "Delete")),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUser() async {
    sharedpref = await SharedPreferences.getInstance();
    var userId = sharedpref.get("id");
    print("getUser $userId");

    setState(() {
      resUserId = userId.toString();
    });

    userCategoryBloc.add(UserCategoryFecthEvent(resUserId));

    // transactionBloc.add(TransactionFetchDataEvent(userId.toString()));
  }

  Container listKategori(List<Usercategory> list) {
    return Container(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            var data = list[index];
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    resKategoriId = data.category!.id;
                    resKategoriName = data.category!.name;
                  });
                  Navigator.pop(context, false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.category!.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  primaryColor: kSecondaryColor,
                  colorScheme:
                      const ColorScheme.light(primary: kSecondaryColor),
                  buttonTheme: const ButtonThemeData(
                      textTheme: ButtonTextTheme.primary)),
              child: child!);
        });

    if (newDate == null) return;

    setState(() {
      resTgl = DateFormat('yyyy/MM/dd').format(newDate);
    });
  }

  Container kategoriField() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Icon(
            FontAwesomeIcons.list,
            color: kHintTextColor,
            size: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Text(
            resKategoriName,
            style: const TextStyle(fontSize: 16),
          )),
          const Icon(
            Icons.arrow_forward_ios,
            color: kHintTextColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Container tanggalField() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.date_range,
            color: kHintTextColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            resTgl,
            style: TextStyle(fontSize: 16),
          )),
          const Icon(
            Icons.arrow_forward_ios,
            color: kHintTextColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Container nominalField() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nominal"),
          Row(
            children: [
              Text(
                "Rp. ",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isPemasukan ? kSecondaryColor : Colors.red),
              ),
              Expanded(
                  child: TextFormField(
                validator: validateValue,
                controller: _tfNominal,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: '0',
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  ToggleSwitch switchTogle() {
    return ToggleSwitch(
      minWidth: SizeConfig.screenWidth,
      cornerRadius: 20.0,
      activeBgColors: [
        [Colors.green[800]!],
        [Colors.red[800]!]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: isPemasukan ? 0 : 1,
      totalSwitches: 2,
      labels: const ['Pemasukan', 'Pengeluaran'],
      radiusStyle: true,
      onToggle: (index) {
        print('switched to: $index');
        setState(() {
          if (index == 0) {
            isPemasukan = true;
            rolePemasukan = "1";
          } else {
            isPemasukan = false;
            rolePemasukan = "2";
          }
        });
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class FormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  const FormField({Key? key, required this.hintText, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: kSecondaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: kSecondaryColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: kHintTextColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
