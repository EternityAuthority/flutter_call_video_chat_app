import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/urlConstants.dart';

class UserListLoad {
  static Future<UsersList> allUsers(context) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.getUsers, headers: headers);

       //print(response.body);

      if (response.statusCode == 200) {
        return UsersList.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.response.toString());
    }

    return null;
  }

  static Future<UsersList> getAllChats(context) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.getChats, headers: headers);
    
      if (response.statusCode == 200) {
        return UsersList.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
