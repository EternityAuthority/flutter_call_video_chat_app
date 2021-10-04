import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/urlConstants.dart';
import 'package:http/http.dart' as http;

class AccountService {
  static Future<bool> reset(context, email) async {
    var data = {"email": '$email'};

    try {
      var headers = {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      final response = await http.post(WayaAPI.reset,
          headers: headers, body: json.encode(data));

      print(response.body);
      if (response.body.contains('Unauthenticated.')) {
        eraseAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }
      if (response.body.contains('account not found')) {
        Fluttertoast.showToast(
            msg: "Account not Found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0);
        return null;
      }

      if (response.statusCode == 200 && response.body.contains('been sent')) {
        Fluttertoast.showToast(
            msg: "Invitation Sent",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An Error Occured",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 2,
          backgroundColor: Colors.amber[800].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 14.0);
      print("Got error: ${e.toString()}");
    }
    return null;
  }
}
