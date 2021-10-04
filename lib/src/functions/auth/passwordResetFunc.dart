import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/utils/urlConstants.dart';

/*  Service class for authentication  of users with the cardless api*/
abstract class WalletServices {
  static var errorMsg;

  static fundWallet(context, {@required amount}) async {
    var loginData;
    try {
      //POST REQUEST BUILD

      var headers = {
        //'Authorization': 'Bearer ' + await getItemData(key: 'token'),
        'Content-Type': 'application/json'
      };

      var authData = {
        'amount': amount,
      };

      var data = json.encode(authData);

      final response = await http.post(WayaAPI.verify, headers: headers, body: data);

      final String res = response.body;
      final int statusCode = response.statusCode;
      print(loginData);

      if (statusCode == 200) {
        loginData = json.decode(res);

        // login = LoginModel.fromJson(json.decode(res));
        loginData = response.body;
        if (response.body.toLowerCase().contains('successful')) {
          print("Verification Data from Reset Function" + response.body);

          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Success"),
                    content:
                        new Text("Password Reset Successful, Please Login"),
                  ));
          await new Future.delayed(const Duration(seconds: 4));

          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(
                    loginData: null,
                  ),
            ),
          );

          return response.body;
        }

        /// isLoading = false;
        return loginData;
      } else if (response.statusCode.toString() != "200" ||
          response.body.toLowerCase().contains('error":true') ||
          response.body.toLowerCase().contains('token')) {
        Map<String, dynamic> jsom = json.decode(response.body);
        if (response.body.toString().toLowerCase().contains("msg")) {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Error: " + jsom["error_code"]),
                    content: new Text(jsom["msg"]),
                  ));
        } else if (response.body
            .toString()
            .toLowerCase()
            .contains("unauthorized")) {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Error"),
                    content: new Text("Invlid Password"),
                  ));
        }

        await new Future.delayed(const Duration(seconds: 4));

        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
                  loginData: null,
                ),
          ),
        );
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Error"),
                content: new Text("'${e.toString()}"),
              ));

      /// isLoading = false;
      print("Got error: ${e.toString()}");
    }
    return loginData;
  }

 }
