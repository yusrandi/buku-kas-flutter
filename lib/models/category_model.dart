class CategoryModel {
  String responsecode = "";
  String responsemsg = "";
  List<Category> category = [];

  CategoryModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.category});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    data['category'] = category.map((v) => v.toJson()).toList();
    return data;
  }
}

class Category {
  int id = 0;
  String name = "";
  String role = "";
  int isSelected = 0;

  Category(
      {required this.id,
      required this.name,
      required this.role,
      required this.isSelected});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['role'] = role;
    data['isSelected'] = isSelected;
    return data;
  }
}
