import 'dart:convert';

import 'package:irza/config/api.dart';
import 'package:irza/models/user_category_model.dart';
import 'package:http/http.dart' as http;

abstract class UserCategoryRepository {
  Future<UserCategoryModel> userCategoryFetchData(String id);
  Future<UserCategoryModel> userCategoryStore(String userId, String categories);
}

class UserCategoryRepositoryImpl implements UserCategoryRepository {
  @override
  Future<UserCategoryModel> userCategoryFetchData(String id) async {
    var _response =
        await http.get(Uri.parse(Api.instance.usercategoryURL + "/" + id));
    // print(" TransactionRepo ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("StrowFetchData $data");
      UserCategoryModel model = UserCategoryModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<UserCategoryModel> userCategoryStore(
      String userId, String categories) async {
    var _response =
        await http.post(Uri.parse(Api.instance.usercategoryURL), body: {
      "user_id": userId,
      "categories": categories,
    });
    print("transStore ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("Data $data");
      UserCategoryModel model = UserCategoryModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}
