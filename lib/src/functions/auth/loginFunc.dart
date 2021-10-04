import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/models/auth/login.dart';
import 'package:waya/models/users/profileModel.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/src/functions/users/usersList.dart';
import 'package:waya/src/views/controller.dart';
import 'package:waya/src/views/layout/auth/verify.dart';
import 'package:waya/utils/error.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/urlConstants.dart';

class LoginFunc {
  static postData(password, phoneNumber, context) async {
    //D:pLC&g&Uz$azD=~$jCG:U#h<wSrfHTB

    saveItem(item: '$password', key: 'pass');

    try {
      //POST REQUEST HEADERS
      dynamic data = {"phone": phoneNumber, "password": password};

      //POST REQUEST BUILD
      final response = await http.post(WayaAPI.login,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));

      print(response.body);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        //  print("Response status: ${response.statusCode}");
        // print("Response status: ${response.headers}");
        //print("Response body: ${response.body}");

        if (response.body.toString().toLowerCase().contains("error_code")) {
          wayaDialog(
              context: context,
              title: "Error: " + json.decode(response.body)["error_code"],
              content: json.decode(response.body)["msg"]);
          await new Future.delayed(const Duration(seconds: 4));
          if (response.body.contains('verif')) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Verify(phone: phoneNumber, password: password),
              ),
            );
          }
          return true;
        }

        ///Handling Success in login
        if (response.body.toLowerCase().contains("is_verified") ||
            response.body.toLowerCase().contains("$phoneNumber")) {
          LoginModel loginData =
              LoginModel.fromJson(json.decode(response.body));

          await saveLoginData(loginData: loginData);
          await loadProfileData(
            context,
            loginData: loginData,
          );

          UsersList usersList = await UserListLoad.getAllChats(context);

          await saveUsersList(usersList: usersList);

          return true;
        }
      } else {
        //Handling Error codes from api
        if (response.statusCode.toString() != "200" ||
            response.body.toLowerCase().contains('error":true') ||
            response.body.toLowerCase().contains('token')) {
          if (response.body.toString().toLowerCase().contains("msg")) {
            wayaDialog(
                context: context,
                title: "Error: " + json.decode(response.body)["error_code"],
                content: json.decode(response.body)["msg"]);
          } else if (response.body
              .toString()
              .toLowerCase()
              .contains("unauthorized")) {
            wayaDialog(
                context: context, title: 'Error', content: 'Invlid Password');
          } else {
            wayaDialog(
                context: context,
                title: 'Error',
                content: json.decode(response.body)["error"]);
          }
        }
        return false;
      }
    } catch (e) {
      print(e.toString());
      if (e != null) {
        wayaDialog(
            context: context,
            title: 'Error',
            content: 'An Error Occurred Please Check your Internet Connection');
      }
      return false;
    }

    return false;
  }

  static loadProfileData(context, {LoginModel loginData, String token}) async {
    var bearer = token ?? loginData?.success?.token;

    var headers = {
      'Authorization': "Bearer $bearer",
      'Content-type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
    };

    try {
      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.getProfileData, headers: headers);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        ///Handling Success in login
        // print(" Data from Login Function " + responseData);

        UserProfileModel profileData =
            UserProfileModel.fromJson(json.decode(response.body));

        /// [saveProfileData] FOR LATER

        await saveProfileData(profileData: profileData);
        var mData = await getProfileData();

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Controller(
              getProfileData: mData,
            ),
          ),
        );
        return null;
        // return responseData;

      } else {
        //Handling Error codes from api
        if ('${response.statusCode}' != "200" ||
            '${response.body}'.toLowerCase().contains('error":true') ||
            '${response.body}'.toLowerCase().contains('token')) {
          wayaDialog(
              context: context,
              title: "Error:  ${response.statusCode}",
              content: 'Couldnt Load Profile');
        }
      }
    } catch (e) {
      if (e != null) {
        /*  wayaDialog(
            context: context, title: 'Error', content: '${e.toString()}');
       */
      }
    }

    return null;
  }
}
