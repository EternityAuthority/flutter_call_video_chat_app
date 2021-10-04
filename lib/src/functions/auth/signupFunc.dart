import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/src/views/layout/auth/verify.dart';
import 'package:waya/utils/error.dart';
import 'package:waya/utils/urlConstants.dart';

class SignupFunc {
  static registerNormalUser(
    context, {
    @required String fullname,
    @required String password,
    @required String phoneNumber,
  }) async {
    try {
      //POST REQUEST HEADERS
      Map data = {
        "full_name": fullname,
        "phone": phoneNumber,
        "password": password,
        "password_confirmation": password
      };
      // print(jsonEncode(data));
      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.register,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));


      print("Response body: ${response.body}");

      if (response.body.toLowerCase().contains("success")) {
        print("Data from Signup Function" + response.body);

        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: new Text("Success"),
                content: new Text(
                    "Registration Successful, An OTP Code has been sent to " +
                        phoneNumber +
                        ". Please use it for verification")));

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verify(phone: phoneNumber, password: password,),
          ),
        );
      }else{

        wayaDialog(
            context: context, title: 'Error', content: 'Ann Error Occurred');

      }

      if (response.body.toLowerCase().contains("taken")) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text("The phone has already been taken."),
                ));

        return null;
      }
    } catch (e) {
      if (e.toString() != null) {
        //  String msg = e.response.data.toString();

        wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');

        //  Navigator.pop(context);
        return null;
      }
    }
  }

  static registerMerchant(
    context, {
    @required String merchantName,
    @required String phoneNumber,
    @required String merchantState,
    @required String merchantStreet,
    @required String merchantCity,
    @required String merchantCountry,
    @required String password,
  }) async {
    try {
      //POST REQUEST HEADERS
      Map data = {
        "is_merchant": 1,
        "phone": phoneNumber,
        "street": merchantStreet,
        "city": merchantCity,
        "merchant_name":merchantName,
        "country": merchantCountry,
        "password": password,
        "state": merchantState,
        "password_confirmation": password
      };
      // print(jsonEncode(data));
      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.register,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));

      print("Response body: ${response.body}");

      if (response.body.toLowerCase().contains("success")) {
        print("Data from Signup Function" + response.body);

        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: new Text("Success"),
                content: new Text(
                    "Registration Successful, An OTP Code has been sent to " +
                        phoneNumber +
                        ". Please use it for verification")));
        await new Future.delayed(const Duration(seconds: 4));

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verify(phone: phoneNumber, password: password,),
          ),
        );
      }

      if (response.body.toLowerCase().contains("taken")) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text("The phone has already been taken."),
                ));

      return null; 
      }
    } catch (e) {
      if (e.toString() != null) {
        //  String msg = e.response.data.toString();

        wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');

        //  Navigator.pop(context);
        return null;
      }
    }
  }
}
