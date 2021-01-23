import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  String user;
  factory AppData() {
    return _appData;
  }

  static displayToast(String msg, Color col) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: col,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  AppData._internal();
}

final appData = AppData();
