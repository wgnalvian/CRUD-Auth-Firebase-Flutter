import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/model/data_model.dart';

import 'package:http/http.dart' as http;

class DataProvider extends ChangeNotifier {
  String _token = "";
  String _userid = "";

  List<DataModel> _data = [];
  List<DataModel> get data => _data;
  // ignore: prefer_final_fields
  Uri _urlDB = Uri.parse(
      "https://flutter-crud-provider-default-rtdb.firebaseio.com/data.json");
  getDataAuh(String token, String userid) {
    _token = token;
    _userid = userid;

    notifyListeners();
  }

  Future<void> addData(String name, String description) async {
    final dataPost = {
      "name": name,
      "description": description,
      "createdAt": DateTime.now().toString(),
      "updatedAt": DateTime.now().toString(),
      "userId": _userid
    };
    dynamic data = await http.post(
        Uri.parse(
            "https://flutter-crud-provider-default-rtdb.firebaseio.com/data.json?auth=$_token"),
        body: jsonEncode(dataPost),
        headers: {"Content-Type": "application/json"});

    DataModel rawData = DataModel(
        id: jsonDecode(data.body)['name'],
        name: name,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: _userid);
    _data.add(rawData);

    notifyListeners();
  }

  Future<Map<String, String>?> getData(String? id) async {
    if (id != null) {
      final dataItem = await http
          .get(Uri.parse(
              'https://flutter-crud-provider-default-rtdb.firebaseio.com/data/$id.json?auth=$_token'))
          .then((value) => jsonDecode(value.body));

      return {"name": dataItem["name"], "description": dataItem["description"]};
    }

    final dataGet = await http.get(Uri.parse(
        'https://flutter-crud-provider-default-rtdb.firebaseio.com/data.json?auth=$_token&orderBy="userId"&equalTo="${_userid}"'));
    print(dataGet.statusCode);
    print(jsonDecode(dataGet.body));
    final dataDecode = jsonDecode(dataGet.body);

    print(dataGet.statusCode);
    print(dataDecode);

    if (dataDecode.isEmpty) {
      return null;
    }
    for (int i = 0; i < dataDecode.length; i++) {
      if (_userid == dataDecode.values.elementAt(i)["userId"]) {
        _data.add(DataModel(
            id: dataDecode.keys.elementAt(i),
            name: dataDecode.values.elementAt(i)["name"],
            description: dataDecode.values.elementAt(i)["description"],
            createdAt:
                DateTime.parse(dataDecode.values.elementAt(i)["createdAt"]),
            updatedAt:
                DateTime.parse(dataDecode.values.elementAt(i)["updatedAt"]),
            userId: _userid));
      }
    }
    notifyListeners();
    return null;
  }

  Future<void> deleteData(String id) async {
    final dataDelete = await http.delete(Uri.parse(
        "https://flutter-crud-provider-default-rtdb.firebaseio.com/data/$id.json?auth=$_token"));

    _data.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  Future<void> editData(String id, String name, String description) async {
    final response = await http.patch(
        Uri.parse(
            "https://flutter-crud-provider-default-rtdb.firebaseio.com/data/$id.json?auth=$_token"),
        body: jsonEncode({"name": name, "description": description}));
    int index = _data.indexWhere((element) => element.id == id);
    _data[index] = DataModel(
        id: id,
        name: name,
        description: description,
        createdAt: _data[index].createdAt,
        updatedAt: DateTime.now(),
        userId: _userid);
    notifyListeners();
  }
}
