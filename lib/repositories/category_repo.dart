import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:irza/config/api.dart';
import 'package:irza/models/category_model.dart';

abstract class CategoryRepository {
  Future<CategoryModel> categoryFetchData();
}

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<CategoryModel> categoryFetchData() async {
    var _response = await http.get(Uri.parse(Api.instance.categoryURL));
    print("CategoryRepository , ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("StrowFetchData $data");
      CategoryModel model = CategoryModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}
