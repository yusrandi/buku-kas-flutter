import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/helper/keyboard.dart';
import 'package:irza/models/user_model.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';
import 'package:irza/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreenBody extends StatefulWidget {
  const UserScreenBody({Key? key}) : super(key: key);

  @override
  _UserScreenBodyState createState() => _UserScreenBodyState();
}

class _UserScreenBodyState extends State<UserScreenBody> {
  late UserBloc userBloc;
  late SharedPreferences sharedpref;

  final _formKey = GlobalKey<FormState>();

  final _userName = TextEditingController();
  final _userPassword = TextEditingController();

  bool _passwordVisible = false;
  String resId = "";

  String? validatePass(value) {
    if (value.isEmpty) {
      return null;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial || state is UserLoadingState) {
          return _buildLoading();
        } else if (state is UserGetSuccess) {
          return buildUser(state.user.user);
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Center buildUser(User? user) {
    _userName.text = user!.name;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.user, size: 50),
                const SizedBox(height: 8),
                Text(user.email, style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                const Divider(color: Colors.black),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: kSecondaryColor,
                  controller: _userName,
                  decoration: buildInputDecoration(
                      FontAwesomeIcons.user, "Enter your name"),
                ),
                const SizedBox(height: 16),
                // passwordField(),
                TextFormField(
                  validator: validatePass,
                  cursorColor: kSecondaryColor,
                  controller: _userPassword,
                  decoration: buildInputDecoration(
                      FontAwesomeIcons.lock, "New Password ?"),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                GestureDetector(
                    onTap: () {
                      // gotoHomePage();
                      if (_formKey.currentState!.validate()) {
                        var name = _userName.text.trim();
                        var password = _userPassword.text.trim();

                        userBloc.add(UserUpdateEvent(
                            id: resId, name: name, password: password));
                      }

                      KeyboardUtil.hideKeyboard(context);
                      _userPassword.text = "";
                    },
                    child: const PrimaryButton(btnText: 'Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      cursorColor: kSecondaryColor,
      controller: _userPassword,
      keyboardType: TextInputType.text,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.black),
        hintText: 'Enter your password',
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: kSecondaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),

        prefixIcon: const Icon(FontAwesomeIcons.lock, size: 18),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kSecondaryColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kHintTextColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  void getUser() async {
    sharedpref = await SharedPreferences.getInstance();
    var userId = sharedpref.get("id");
    resId = userId.toString();
    print("getUser $userId");

    userBloc.add(GetUserEvent(id: userId.toString()));
  }

  Widget _buildLoading() {
    return const Center(
      child: Text("Please Wait . . ."),
    );
  }
}
