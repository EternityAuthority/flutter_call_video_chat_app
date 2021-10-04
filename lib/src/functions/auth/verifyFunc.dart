import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/src/views/layout/auth/verify.dart';
import 'package:waya/utils/error.dart';
import 'package:waya/utils/urlConstants.dart';

import 'loginFunc.dart';

class VerifyFunc {
  static postData(phoneNumber, otp, context, password) async {
    String responseData;

    try {
      //POST REQUEST HEADERS
      var data = {"phone": phoneNumber, "otp": otp};
      print(json.encode(data));

      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.verify,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));

      responseData = response.body;

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.body.toLowerCase().contains('successful')) {
        print("Verification Data from Verify Function" + response.body);
        responseData = response.body;
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Success"),
                  content: new Text("Verification Successful, Please Wait"),
                ));
        await new Future.delayed(const Duration(seconds: 4));

        if (password != null) {
          await LoginFunc.postData(password, phoneNumber, context);
        } else {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        }

        return response.body;
      } else {
        print(response.body);
        Map<String, dynamic> jsom = json.decode(response.body);
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text(jsom["msg"]),
                ));
        await new Future.delayed(const Duration(seconds: 4));

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verify(
              phone: phoneNumber,
              password: password,
            ),
          ),
        );
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.toString() != null) {
        //  String msg = e.response.data.toString();

        wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');

        //  Navigator.pop(context);
        await new Future.delayed(const Duration(seconds: 4));
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Verify(phone: phoneNumber, password: password),
          ),
        );
      }
    }

    return responseData;
  }
}
