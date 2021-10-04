import 'dart:typed_data';

import 'package:flutter/material.dart';

class FilteredUserList {
  List<UserContact> data;

  FilteredUserList({this.data});

  FilteredUserList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<UserContact>();
      json['data'].forEach((v) {
        data.add(new UserContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserContact {
  String name, phone, lastMessage, initials;
  int recieverID;

  Uint8List avatar;

  UserContact(
      {@required this.initials,
      @required this.avatar,
      @required this.recieverID,
      @required this.lastMessage,
      @required this.name,
      @required this.phone});

  UserContact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    initials = json['initials'];
    avatar = json['avatar'];
    recieverID = json['recieverID'];
    lastMessage = json['lastMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['initials'] = this.initials;
    data['avatar'] = this.avatar;
    data['recieverID'] = this.recieverID;
    data['lastMessage'] = this.lastMessage;
    return data;
  }
}
