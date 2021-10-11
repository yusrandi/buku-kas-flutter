import 'dart:convert';

import 'package:irza/config/api.dart';
import 'package:irza/models/transaction_model.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRepo {
  Future<TransactionModel> transFetchData(String id);
  Future<TransactionModel> transDelete(String id);
  Future<TransactionModel> transStore(Transaction transaction);
  Future<TransactionModel> transUpdate(Transaction transaction);
}

class TransactionRepoImpl implements TransactionRepo {
  @override
  Future<TransactionModel> transFetchData(String id) async {
    var _response =
        await http.get(Uri.parse(Api.instance.transactionURL + "/" + id));
    // print(" TransactionRepo ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("StrowFetchData $data");
      TransactionModel model = TransactionModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<TransactionModel> transDelete(String id) async {
    var _response =
        await http.delete(Uri.parse(Api.instance.transactionURL + "/" + id));
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("Data $data");
      TransactionModel model = TransactionModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<TransactionModel> transStore(Transaction transaction) async {
    var _response =
        await http.post(Uri.parse(Api.instance.transactionURL), body: {
      "category_id": transaction.categoryId.toString(),
      "user_id": transaction.userId.toString(),
      "title": transaction.title,
      "date": transaction.date,
      "nominal": transaction.nominal,
      "notes": transaction.notes,
      "status": transaction.status,
    });
    print("transStore ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("Data $data");
      TransactionModel model = TransactionModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<TransactionModel> transUpdate(Transaction transaction) async {
    var _response = await http.put(
        Uri.parse(
            Api.instance.transactionURL + "/" + transaction.id.toString()),
        body: {
          "category_id": transaction.categoryId.toString(),
          "user_id": transaction.userId.toString(),
          "title": transaction.title,
          "date": transaction.date,
          "nominal": transaction.nominal,
          "notes": transaction.notes,
          "status": transaction.status,
        });
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("Data $data");
      TransactionModel model = TransactionModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}
