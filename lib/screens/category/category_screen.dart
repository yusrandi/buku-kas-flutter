import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irza/blocs/category_bloc/category_bloc.dart';
import 'package:irza/blocs/user_category_bloc/user_category_bloc.dart';
import 'package:irza/repositories/category_repo.dart';
import 'package:irza/repositories/user_category_repo.dart';
import 'package:irza/screens/category/body.dart';
import 'package:irza/utils/constants.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = "/category";

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Pilih Kategori", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[kSecondaryColor, kPrimaryColor])),
        ),
      ),
      body: BlocProvider(
        create: (context) => CategoryBloc(CategoryRepositoryImpl()),
        child: BlocProvider(
          create: (context) => UserCategoryBloc(UserCategoryRepositoryImpl()),
          child: Body(),
        ),
      ),
    );
  }
}
