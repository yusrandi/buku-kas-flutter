import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irza/blocs/user_bloc/user_bloc.dart';
import 'package:irza/config/shared_info.dart';
import 'package:irza/helper/keyboard.dart';
import 'package:irza/screens/auth/or_divider.dart';
import 'package:irza/screens/home/home_screen.dart';
import 'package:irza/utils/constants.dart';
import 'package:irza/utils/size_config.dart';
import 'package:irza/widgets/primary_button.dart';

class SignInBody extends StatefulWidget {
  final UserBloc bloc;
  const SignInBody({Key? key, required this.bloc}) : super(key: key);

  @override
  _SignInBodyState createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  late SharedInfo _sharedInfo;

  final _userEmail = TextEditingController();
  final _userName = TextEditingController();
  final _userPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _isLogin = true;

  FocusNode myFocusNode = FocusNode();

  String? validatePass(value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  String? validateName(value) {
    if (value.isEmpty) {
      return kNamelNullError;
    } else {
      return null;
    }
  }

  String? validateEmail(value) {
    if (value.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _sharedInfo = SharedInfo();

    // EasyLoading.show(status: 'loading...');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print(state);
        if (state is UserGetError) {
          print("State ${state.error}");
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        } else if (state is UserGetSuccess) {
          EasyLoading.dismiss();
          print("State ${state.user.responsecode}");
          // ignore: unrelated_type_equality_checks
          if (state.user.responsecode == "1") {
            EasyLoading.showSuccess("Welcome");

            _sharedInfo.sharedLoginInfo(state.user.user!.id,
                state.user.user!.email, state.user.user!.name);
            gotoAnotherPage(HomeScreen(bloc: widget.bloc));
          } else {
            EasyLoading.showError(state.user.responsemsg);
          }
        } else if (state is UserLoadingState || state is UserInitial) {
          EasyLoading.show(status: 'wait a second');
        } else if (state is UserLoggedInState)
          gotoAnotherPage(HomeScreen(bloc: widget.bloc));
      },
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Selamat Datang",
                        style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    Visibility(
                      child: TextFormField(
                        controller: _userName,
                        validator: validateName,
                        decoration: buildInputDecoration(
                            FontAwesomeIcons.user, "Enter your name"),
                      ),
                      visible: !_isLogin,
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextFormField(
                      cursorColor: kSecondaryColor,
                      controller: _userEmail,
                      validator: validateEmail,
                      decoration: buildInputDecoration(
                          FontAwesomeIcons.envelope, "Enter Your Email"),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    passwordField(),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    GestureDetector(
                        onTap: () {
                          // gotoHomePage();
                          if (_formKey.currentState!.validate()) {
                            var name = _userName.text.trim();
                            var email = _userEmail.text.trim();
                            var password = _userPass.text.trim();

                            _isLogin
                                ? widget.bloc.add(UserLoginEvent(
                                    email: email, password: password))
                                : widget.bloc.add(UserRegisterEvent(
                                    name: name,
                                    email: email,
                                    password: password));
                          }

                          KeyboardUtil.hideKeyboard(context);
                        },
                        child: PrimaryButton(
                            btnText: _isLogin ? 'Login' : 'Register')),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_isLogin) {
                                _isLogin = false;
                              } else {
                                _isLogin = true;
                              }
                            });
                          },
                          child: Text(
                            _isLogin ? "Sign Up" : "Sign In",
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: _userPass,
      validator: validatePass,
      keyboardType: TextInputType.text,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        labelText: 'Password',
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

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
