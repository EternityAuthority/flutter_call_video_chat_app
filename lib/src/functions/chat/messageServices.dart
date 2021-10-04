import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waya/models/chat/messageList.dart';
import 'package:waya/models/chat/newMessage.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/urlConstants.dart';

class MessageServices {
  static Future<MessageModel> sendMessage(context,
      {@required int id, @required String message, image}) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var data = {
        "receiver_id": id,
        "message": message.isNotEmpty ? message : 'Media',
        "image_url": image
      };
       print(data);

      //POST REQUEST BUILD

      final response = await http.post(WayaAPI.sendMessage,
          headers: headers, body: json.encode(data));
      print(response.body);

      if (response.statusCode == 200) {
        if (response.body.contains('required')) {
          return null;
        }
        //  saveItem(item: '${response.body}', key: 'message');
        return MessageModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.toString());
    }

    return null;
  }

  static Future<MessageModel> editMessage(context,
      {@required conversationId,
      @required String message,
      @required String messageId}) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var data = {
        "conversation_id": conversationId,
        "message_id": messageId,
        "message": message
      };
      // print(image);

      //POST REQUEST BUILD

      final response = await http.post(WayaAPI.editMessage,
          headers: headers, body: json.encode(data));
      //  print(response.body);

      if (response.statusCode == 200) {
        if (response.body.contains('required')) {
          return null;
        }
        //  saveItem(item: '${response.body}', key: 'message');
        return MessageModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.toString());
    }

    return null;
  }

  static Future<MessageList> getMessages(context,  id) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var body = {"conversation_id": id};

      final response = await http.post(WayaAPI.getMessages,
          body: json.encode(body), headers: headers);

      //print(response.body);
      if (response.body.contains('Unauthenticated.')) {
        eraseAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }

      if (response.statusCode == 200) {
        //  saveItem(item: '${response.body}', key: 'message');
        return MessageList.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.toString());
    }

    return null;
  }

  static Future<bool> deleteMessages(context, {int id}) async {
    try {
      var headers = {
        'Authorization':
            "Bearer " + (await getProfileData()).loginData.success.token,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      };

      var body = {
        "id": id // id of the person you're chatting with
      };

      final response = await http.post(WayaAPI.clearChat,
          headers: headers, body: json.encode(body));

      // print(response.body);

      if (response.statusCode == 200) {
        //  saveItem(item: '${response.body}', key: 'message');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.toString());
    }

    return false;
  }
}
