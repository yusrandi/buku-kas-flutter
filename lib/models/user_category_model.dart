import 'category_model.dart';
import 'user_model.dart';

class UserCategoryModel {
  String responsecode = "";
  String responsemsg = "";
  List<Usercategory> usercategory = [];

  UserCategoryModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.usercategory});

  UserCategoryModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['usercategory'] != null) {
      usercategory = <Usercategory>[];
      json['usercategory'].forEach((v) {
        usercategory.add(Usercategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    data['usercategory'] = usercategory.map((v) => v.toJson()).toList();
    return data;
  }
}

class Usercategory {
  int id = 0;
  int categoryId = 0;
  int userId = 0;
  Category? category;
  User? user;

  Usercategory(
      {required this.id,
      required this.categoryId,
      required this.userId,
      this.category,
      this.user});

  Usercategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
