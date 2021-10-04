import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:waya/models/chat/messageList.dart';
import 'package:waya/src/functions/fcm/cloudMessagingServices.dart';
import 'package:get/get.dart';
import 'package:waya/src/views/layout/agora-rtc.dart';
import 'package:waya/src/views/layout/social/calls/intersitCall.dart';
import 'package:waya/src/views/layout/social/calls/providers/callController.dart';
import 'package:waya/utils/margin_utils.dart';
import '../persistence.dart';
// import 'src/views/layout/agora-rtc.dart';

BuildContext contextMain;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackgroundMessage: $message");
  return Future<void>.value();
}

Future onSelectNotification(String payload) async {}

class NotificationHandler {
  CallController callController;

  // NotificationHandler({this.callController});

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  StreamSubscription iosSubscription;

  // static final NotificationHandler _singleton =
  //     new NotificationHandler._internal(callController);

  factory NotificationHandler(CallController callController) {
    // return _singleton;
    return NotificationHandler._internal(callController);
  }
  NotificationHandler._internal(this.callController);

  initializeFcmNotification() async {
    try {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      //configure FCM
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

      //set iOS
      if (Platform.isIOS) {
        iosSubscription =
            _firebaseMessaging.onIosSettingsRegistered.listen((data) {
          // save the token  OR subscribe to a topic here
        });
        _saveDeviceToken(_firebaseMessaging);

        _firebaseMessaging
            .requestNotificationPermissions(IosNotificationSettings());
      } else {
        _saveDeviceToken(_firebaseMessaging);
      }

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage from handler: $message");
          // if (message['data']['type'] == 'CALL_NOTIFICATION') {
          //   //TODO: redirect to call screen
          //   Get.to(Intersit());
          // } else {
          //   _showItemDialog(message);
          //   // _navigateToItemDetail(message);
          // }

          if (message['data']['type'] == 'CALL_NOTIFICATION') {
            //TODO: redirect to call screen

            var channelId = message['data']['channel_id'];
            var callType = message['data']['call_type'];
            var caller = message['data']['caller'];

            // Get.to(AgoraCallInterface(
            //   isVideo: callType == 'video',
            //   fullName: caller,
            //   channelId: channelId,
            //   // hangUp: this._hangUp,
            // ));

            callController.currentView = IntersitCall(
              callController.setCallAnswered,
              callController.hangUp,
              fullName: caller,
              isVideo: callType == 'video',
            );

            // navigatorKey.currentState
            //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            //   return IntersitCall(
            //     callController.setCallAnswered,
            //     callController.hangUp,
            //     fullName: caller,
            //     isVideo: callType == 'video',
            //   );
            // }));

            // navigatorKey.currentState.push();

            // Get.to(IntersitCall(
            //   callController.setCallAnswered,
            //   callController.hangUp,
            //   fullName: caller,
            //   isVideo: callType == 'video',
            // ));
          } else {
            _navigateToItemDetail(message);
          }
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          if (message['data']['type'] == 'CALL_NOTIFICATION') {
            //TODO: redirect to call screen

            var channelId = message['data']['channel_id'];
            var callType = message['data']['call_type'];
            var caller = message['data']['caller'];

            FlutterRingtonePlayer.playRingtone(looping: true);

            Get.to(IntersitCall(
              callController.setCallAnswered,
              callController.hangUp,
              fullName: caller,
              isVideo: callType == 'video',
            ));

            // Get.to(AgoraCallInterface(
            //   isVideo: callType == 'video',
            //   fullName: caller,
            //   channelId: channelId,
            //   // hangUp: this._hangUp,
            // ));
          } else {
            _navigateToItemDetail(message);
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          if (message['data']['type'] == 'CALL_NOTIFICATION') {
            //TODO: redirect to call screen

            var channelId = message['data']['channel_id'];
            var callType = message['data']['call_type'];
            var caller = message['data']['caller'];

            Get.to(AgoraCallInterface(
              isVideo: callType == 'video',
              fullName: caller,
              channelId: channelId,
              // hangUp: this._hangUp,
            ));
          } else {
            _navigateToItemDetail(message);
          }
        },
      );

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildDialog(BuildContext context, Map<String, dynamic> item) {
    var message = MessageItemModel.fromJson(json.decode(item['notification']
            ['body']
        .toString()
        .split(':')
        .sublist(1)
        .join(':')));
    // print( "" + );

    return AlertDialog(
      title: Text("${item['notification']['title']}"),
      content: Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Text(
                " New message from ${item['notification']['body'].split(':')[0]}"),
            customYMargin(10),
            Text(message?.message ?? ''),
          ],
        ),
      ),
      actions: <Widget>[
        /* FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ), */
        FlatButton(
          child: const Text('View'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: contextMain,
      builder: (_) => _buildDialog(contextMain, message),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    //final Item item = _itemForMessage(message);
    // Clear away dialogs
    /* Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    } */
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      if (message['data']['type'] == 'CALL_NOTIFICATION') {
        //TODO: redirect to call screen
        CallController callController = CallController();
        FlutterRingtonePlayer.playRingtone(looping: true);

        var channelId = message['data']['channel_id'];
        var callType = message['data']['call_type'];
        var caller = message['data']['caller'];

        Get.to(IntersitCall(
          callController.setCallAnswered,
          callController.hangUp,
          fullName: caller,
          isVideo: callType == 'video',
        ));
        // Get.to(Intersit());
      } else {
        final dynamic notification = message['notification'];

        _navigateToItemDetail(message);
      }
    }

    if (message.containsKey('notification')) {
      // Handle notification message

    }

    // Or do other work.
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken(FirebaseMessaging firebaseMessaging) async {
    String fcmToken = await firebaseMessaging.getToken();
    print("FCM_TOKEN: $fcmToken");
    print('Push Messaging token: $fcmToken');

    await CloudMessagingServices.updateFCMToken(contextMain, token: fcmToken);
    await saveItem(item: fcmToken, key: 'fcmToken');
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
