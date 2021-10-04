import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:waya/models/fcm/NotifsModel.dart';
import 'package:waya/models/fcm/markAsReadModel.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/urlConstants.dart';
import 'package:http/http.dart' as http;

class CloudMessagingServices {
  static Future<bool> updateFCMToken(
    context, {
    @required String token,
  }) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var data = {"token": "$token"};
      print(data);

      //POST REQUEST BUILD

      final response = await http.post(WayaAPI.fcmToken,
          headers: headers, body: json.encode(data));
      print("fcm" + response.body);

      if (response.statusCode == 200) {
        if (response.body.contains('updated')) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }

    return false;
  }

  static Future<NotifsModel> getAllNotifs(context) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.allNotifs, headers: headers);

      if (response.statusCode == 200) {
        return NotifsModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<NotifsModel> getReadNotifs(context) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.allRead, headers: headers);

      if (response.statusCode == 200) {
        return NotifsModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<NotifsModel> getUnreadNotifs(context) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      //POST REQUEST BUILD

      final response = await http.get(WayaAPI.allUnread, headers: headers);

      if (response.statusCode == 200) {
        return NotifsModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<MarkAsReadModel> markAsRead(context, notifId) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var data = {"notification_id": notifId};
      //POST REQUEST BUILD

      final response = await http.post(WayaAPI.markRead,
          headers: headers, body: json.encode(data));

      // print("body: " + response.body);

      if (response.statusCode == 200) {
        return MarkAsReadModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<bool> sendCallNotif(
    context, {
    @required int receiverId,
    @required String callType,
  }) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var data = {"receiver_id for call": receiverId, "call_type": callType};
      print(data);

      //POST REQUEST BUILD

      final response = await http.post(WayaAPI.callUser,
          headers: headers, body: json.encode(data));
      print("fcm" + response.body);

      if (response.statusCode == 200) {
        if (response.body.contains('sent')) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }

    return false;
  }
}
