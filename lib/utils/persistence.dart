import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waya/models/auth/login.dart';
import 'package:waya/models/chat/allMessages.dart';
import 'package:waya/models/users/profileModel.dart';
import 'package:waya/models/users/usersModel.dart';

///-------------PROFILE DATA----------------///
Future saveProfileData({UserProfileModel profileData}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //print('Saved Profile Data');

  prefs.setString(
      'profileData',
      /* encrypt(data:  */ json.encode(profileData.toJson())) /* .base16) */;
}

Future saveLoginData({LoginModel loginData}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  prefs.setBool('firstTime', false);
  //print('Saved Login Data');

  prefs.setString(
      'loginData',
      /* encrypt(data:  */ json.encode(loginData.toJson())) /* .base16) */;
}

Future saveFilteredUserListData(
    {@required FilteredUserList filteredUserList}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //print('Saved save filteredUserListData Data');

  prefs.setString(
      'filteredUserList',
      /* encrypt(data:  */ json
          .encode(filteredUserList.toJson()) /* ).base16 */);
}

Future saveUsersList({UsersList usersList}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  //print('Saved UsersList Data');

  prefs.setString(
      'usersListData',
      /* encrypt(data: */ json.encode(usersList.toJson()) /* ).base16 */);
}

Future eraseProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //print('Erased Profile Data');
  prefs.remove('loginData');
  prefs.remove('profileData');
}

Future<UsersList> getUsersList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  UsersList usersList;
  if (prefs.getString('usersListData') != null) {
    String usersListJSON =
        /*   decrypt16(encrypted: */ prefs.getString('usersListData' /* ) */);

    usersList = UsersList.fromJson(json.decode(usersListJSON));
    //print(json.decode(usersListJSON));

    //('Fetched UsersList Data');
    return usersList;
  } else {
    return null;
  }
}

Future<FilteredUserList> getFilteredUserList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  FilteredUserList usersList;
  if (prefs.getString('filteredUserList') != null) {
    String usersListJSON =
        /* decrypt16(encrypted: */ prefs.getString('filteredUserList') /* ) */;

    usersList = FilteredUserList.fromJson(json.decode(usersListJSON));
    //print(json.decode(usersListJSON));

    //print('Fetched UsersList Data');
    return usersList;
  } else {
    return null;
  }
}

Future<GetProfileData> getProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  LoginModel loginData;
  UserProfileModel profileData;

  if (prefs.getString('loginData') != null) {
    String decryptedProfileJSON =
        /* decrypt16(encrypted: */ prefs.getString('profileData') /* ) */;
    String decryptedLoginJSON =
        /* decrypt16(encrypted: */ prefs.getString('loginData') /* ) */;

    profileData = UserProfileModel.fromJson(json.decode(decryptedProfileJSON));

    loginData = LoginModel.fromJson(json.decode(decryptedLoginJSON));

   // print('Fetched Profile Data');
    return new GetProfileData(loginData: loginData, profileData: profileData);
  } else {
    return null;
  }
}

Future saveItem({@required item, @required key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //print('Saved New $key Data');
  prefs.setString(key.toString(), /* encrypt(data: */ item) /* .base16) */;
}

Future eraseItem({@required key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //print('Erased $key  Data');
  prefs.remove('$key');
}

eraseItems({List<String> keys}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var i = 0; i < keys.length; i++) {
    prefs.remove('${keys[i]}');
   // print('Erased ${keys[i]} Data');
  }
}

Future<bool> keyExists({@required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.get(key) != null) {
   // print('true');
    return true;
  } else {
   // print('false');
    return false;
  }
}

eraseAll() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  //print('CLEARED DATA');
}

Future<dynamic> getItemData({@required key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('$key') != null
      ? /* decrypt16(encrypted: */ prefs.getString('$key') /* ) */
      : null;
}

class GetProfileData {
  final UserProfileModel profileData;
  final LoginModel loginData;

  GetProfileData({@required this.profileData, @required this.loginData});
}
