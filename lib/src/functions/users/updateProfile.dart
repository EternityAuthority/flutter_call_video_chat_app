import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/src/functions/auth/loginFunc.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/utils/error.dart';
import 'package:waya/utils/persistence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waya/utils/urlConstants.dart';

class UpdateProfileFunc {
  static postData(BuildContext _,
      {@required String email,
      @required String name,
      @required String password,
      var image,
      String city,
      String nationality,
      String state,
      String street}) async {
    try {
      //POST REQUEST HEADERS
      var data = {
        "full_name": name,
        "email": email,
        "profile_pic": image,
        "password": password
      };

      print(data.toString());

      if (street != null)
        data.addAll({
          "street": street,
          "country": nationality,
          "state": state,
          "city": city
        });

      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST
      final response = await http.post(WayaAPI.updateProfile,
          headers: headers, body: json.encode(data));
      print(response.body);

      if (response.statusCode == 200 &&
          response.body.toLowerCase().contains('successful')) {
        Fluttertoast.showToast(
            msg: "Profile update Successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 2,
            backgroundColor: Colors.amber[800].withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 14.0);
        await LoginFunc.loadProfileData(_,
            token: (await getProfileData()).loginData.success.token);
        return response.body;
      } else {
        Map<String, dynamic> jsom = json.decode(response.body);
        Fluttertoast.showToast(
            msg: "Error ${jsom["msg"]}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 2,
            backgroundColor: Colors.amber[800].withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } catch (e) {
      print(e.toString());
      /*  Fluttertoast.showToast(
          msg: "Error An Error Occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 2,
          backgroundColor: Colors.amber[800].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 14.0); */
    }

    return null;
  }

  static Future<String> changePassword(
      {@required String newPassword,
      @required String password,
      @required BuildContext context}) async {
    try {
      //POST REQUEST HEADERS
      var data = {
        "current_password": password,
        "new_password": newPassword,
        "new_password_confirmation": newPassword
      };
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.changePassword,
          headers: headers, body: json.encode(data));

      if (response.statusCode == 200 &&
          response.body.toLowerCase().contains('successful')) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Success"),
                  content: new Text("Successful, Please"),
                ));
        Navigator.pop(context);
        return response.body;
      } else {
        Navigator.pop(context);
        Map<String, dynamic> jsom = json.decode(response.body);
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text(jsom["msg"]),
                ));
      }
    } catch (e) {
      if (e.toString() != null) {
        wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');
      }
    }

    return null;
  }

  static Future<String> deleteAccount(BuildContext context) async {
    try {
      //POST REQUEST HEADERS

      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD
      final response = await http.get(
        WayaAPI.deleteUserAccount,
        headers: headers,
      );

      if (response.statusCode == 200 &&
          response.body.toLowerCase().contains('successful')) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Success"),
                  content: new Text("Successful, Please"),
                ));
        Navigator.pop(context);
        eraseAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        return response.body;
      } else {
        Navigator.pop(context);
        Map<String, dynamic> jsom = json.decode(response.body);
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text(jsom["msg"]),
                ));
      }
    } catch (e) {
      if (e.toString() != null) {
        wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');
      }
    }

    return null;
  }
}
