import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/page/add.dart';
import 'package:flutter_application_2/page/edit.dart';
import 'package:flutter_application_2/page/home.dart';

class Routes {
  static Map<String,Widget Function(BuildContext)> routes = {
    '/home' : (BuildContext context) => Main(),
    '/add' : (BuildContext context) => Add(),
    '/edit' : (BuildContext context) => Edit()
  };
}