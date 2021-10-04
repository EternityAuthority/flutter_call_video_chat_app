import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/src/views/layout/auth/verify.dart';
import 'package:waya/utils/error.dart';
import 'package:waya/utils/urlConstants.dart';

class ResendOTPFunc {
  ResendOTPFunc(String otp, String phoneNumber, BuildContext context);

  static postData(phoneNumber, context) async {

    try {
      //POST REQUEST HEADERS
      var data = {"phone": phoneNumber};

      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.sendOTP,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.body.toLowerCase().contains('successful')) {
        print("Verification Data from ResendOTP Function" + response.body);
       
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Success"),
                  content: new Text("Otp sent successfully to $phoneNumber"),
                ));
        await new Future.delayed(const Duration(seconds: 4));

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verify(
              phone: phoneNumber,
            ),
          ),
        );

        return response.body;
      } else {
        // print(response.body);
        Map<String, dynamic> jsom = json.decode(response.body);
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text(jsom["msg"]),
                ));
        await new Future.delayed(const Duration(seconds: 4));

        return null;
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

        return null;
      }
    }

    return null;
  }
}
