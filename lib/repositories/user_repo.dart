import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:irza/config/api.dart';
import 'package:irza/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> userLogin(String email, String password);
  Future<UserModel> userRegister(String name, String email, String password);
  Future<UserModel> userUpdate(String id, String name, String password);
  Future<UserModel> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel> userLogin(String email, String password) async {
    var _response = await http.post(Uri.parse(Api.instance.loginURL), body: {
      "email": email,
      "password": password,
    });
    print("UserRepositoryImpl ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<UserModel> userRegister(
      String name, String email, String password) async {
    var _response = await http.post(Uri.parse(Api.instance.registerURL), body: {
      "name": name,
      "email": email,
      "password": password,
    });
    print("UserRepositoryImpl ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<UserModel> userUpdate(String id, String name, String password) async {
    var _response =
        await http.put(Uri.parse(Api.instance.userURL + "/" + id), body: {
      "name": name,
      "id": id,
      "password": password,
    });
    print("UserRepositoryImpl ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<UserModel> getUser(String id) async {
    var _response = await http.get(
      Uri.parse(Api.instance.userURL + '/' + id),
    );
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      throw Exception();
    }
  }
}
