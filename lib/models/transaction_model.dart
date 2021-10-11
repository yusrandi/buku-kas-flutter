import 'package:irza/models/category_model.dart';
import 'package:irza/models/user_model.dart';

class TransactionModel {
  String responsecode = "";
  String responsemsg = "";
  List<Transaction> transaction = [];

  TransactionModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.transaction});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['transaction'] != null) {
      transaction = [];
      json['transaction'].forEach((v) {
        transaction.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    data['transaction'] = transaction.map((v) => v.toJson()).toList();
    return data;
  }
}

class Transaction {
  int id = 0;
  int categoryId = 0;
  int userId = 0;
  String title = "";
  String date = "";
  String nominal = "";
  String notes = "";
  String status = "";
  Category? category;
  User? user;

  Transaction(
      {required this.id,
      required this.categoryId,
      required this.userId,
      required this.title,
      required this.date,
      required this.nominal,
      required this.notes,
      required this.status,
      this.category,
      this.user});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    title = json['title'];
    date = json['date'];
    nominal = json['nominal'];
    notes = json['notes'];
    status = json['status'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['title'] = title;
    data['date'] = date;
    data['nominal'] = nominal;
    data['notes'] = notes;
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
