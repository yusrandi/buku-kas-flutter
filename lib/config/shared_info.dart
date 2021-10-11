import 'package:shared_preferences/shared_preferences.dart';

class SharedInfo {
  late SharedPreferences sharedPref;

  void sharedLoginInfo(int id, String email, String name) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setInt("id", id);
    sharedPref.setString("email", email);
    sharedPref.setString("name", name);
  }

  Future<String?> getUserId() async {
    sharedPref = await SharedPreferences.getInstance();
    var userId = sharedPref.get("id");

    return userId.toString();
  }
}
