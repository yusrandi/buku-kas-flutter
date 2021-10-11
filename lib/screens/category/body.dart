import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:irza/blocs/category_bloc/category_bloc.dart';
import 'package:irza/blocs/user_category_bloc/user_category_bloc.dart';
import 'package:irza/models/category_model.dart';
import 'package:irza/models/user_category_model.dart';
import 'package:irza/screens/category/category_model.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Category> cateSelected = [];

  late CategoryBloc categoryBloc;
  late UserCategoryBloc userCategoryBloc;

  late SharedPreferences sharedpref;
  String resId = "";

  @override
  void initState() {
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    userCategoryBloc = BlocProvider.of<UserCategoryBloc>(context);

    categoryBloc.add(CategoryFetchDataEvent());
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCategoryBloc, UserCategoryState>(
      listener: (context, state) {
        print(state);
        if (state is UserCategoryInitialState ||
            state is UserCategoryLoadingState) {
          EasyLoading.show();
        } else if (state is UserCategorySuccessState) {
          EasyLoading.dismiss();
          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitialState || state is CategoryLoadingState) {
            return _buildLoading();
          }
          if (state is CategoryLoadedState) {
            var list = state.datas.category;

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var data = list[index];
                          return CategoryItem(data, index);
                        }),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (cateSelected.length < 2) {
                        EasyLoading.showError("Please Select Min 2 Categories");
                      } else {
                        var categories = "";
                        for (var i = 0; i < cateSelected.length; i++) {
                          if (i > 0) {
                            categories += ",";
                          }
                          categories += cateSelected[i].id.toString();
                        }

                        userCategoryBloc
                            .add(UserCategoryStoreEvent(resId, categories));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[kSecondaryColor, kPrimaryColor])),
                      child: Text(
                        'submit ${cateSelected.length}',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget CategoryItem(Category data, int index) {
    return ListTile(
      title:
          Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: data.isSelected == 1
          ? Icon(Icons.check_circle, color: kPrimaryColor)
          : const Icon(Icons.check_circle_outline, color: Colors.grey),
      onTap: () {
        setState(() {
          data.isSelected == 1 ? data.isSelected = 0 : data.isSelected = 1;
          if (data.isSelected == 1) {
            cateSelected.add(Category(
                id: data.id,
                name: data.name,
                role: data.role,
                isSelected: data.isSelected));
          } else {
            cateSelected.removeWhere((element) => element.name == data.name);
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

  void getUser() async {
    sharedpref = await SharedPreferences.getInstance();
    var userId = sharedpref.get("id");
    print("getUser $userId");

    setState(() {
      resId = userId.toString();
    });

    // transactionBloc.add(TransactionFetchDataEvent(userId.toString()));
  }
}
