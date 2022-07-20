import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String tokenId = "";
  String userId = "";
  DateTime _expireDate = DateTime(2000);
  bool get isAuth {
    if (_expireDate.isAfter(DateTime.now())) {
      return tokenId != "";
    } else {
      tokenId = "";
      userId = "";
      return false;
    }
  }

  String _temptokenId = "";
  String _tempuserId = "";
  DateTime _tempexpireDate = DateTime(2000);

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("tokenId")) {
       print('ada');
      _expireDate = DateTime.parse(prefs.getString("expireDate") as String);
        _tempexpireDate = DateTime.parse(prefs.getString("expireDate") as String);

      if (!DateTime.now().isBefore(_expireDate)) {
        return logout();
      }
      tokenId = prefs.getString("tokenId") as String;
      userId = prefs.getString("userId") as String;
      _autologout();
     
      print(prefs.getString("tokenId"));
      notifyListeners();
    }else{
      print("tidak ada");
    }
  }

  void changeData() async {
    tokenId = _temptokenId;
    userId = _tempuserId;
    _expireDate = _tempexpireDate;



    notifyListeners();
  }

  Future<void> SignUp(String email, String password) async {
    final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBjbeoi156AUdL6uaaRJ_YkbgDIX-7mi4Y"),
        body: jsonEncode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(jsonDecode(response.body)['expiresIn']);
    if (response.statusCode == 400) {
      throw (jsonDecode(response.body)['error']["message"]);
    } else if (response.statusCode == 200) {
      _temptokenId = jsonDecode(response.body)["idToken"];
      _tempuserId = jsonDecode(response.body)["localId"];
      _tempexpireDate = DateTime.now().add(
          Duration(seconds: int.parse(jsonDecode(response.body)['expiresIn'])));
    }
  }

  Future<void> SignIn(String email, String password) async {
    final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBjbeoi156AUdL6uaaRJ_YkbgDIX-7mi4Y"),
        body: jsonEncode(
            {"email": email, "password": password, "returnSecureToken": true}));

    if (response.statusCode == 400) {
      throw (jsonDecode(response.body)['error']["message"]);
    } else if (response.statusCode == 200) {
      _temptokenId = jsonDecode(response.body)["idToken"];
      _tempuserId = jsonDecode(response.body)["localId"];
      _tempexpireDate = DateTime.now().add(
          Duration(seconds: int.parse(jsonDecode(response.body)['expiresIn'])));

      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString("tokenId", _temptokenId);
      pref.setString("userId", _tempuserId);
      pref.setString("expireDate", _tempexpireDate.toIso8601String());

      print(pref.getString("tokenId"));
    }
    _autologout();
    print(response.statusCode);
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    _expireDate = DateTime(2000);
    tokenId = "";
    userId = "";

    notifyListeners();
  }

  void _autologout() {
    Timer(
        Duration(
            seconds: DateTimeRange(start: DateTime.now(), end: _tempexpireDate)
                .duration
                .inSeconds),
        () => logout());
  }
}
