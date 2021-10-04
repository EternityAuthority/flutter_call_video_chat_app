import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:waya/models/chat/messageList.dart';
import 'package:waya/src/views/layout/social/calls/intersitCall.dart';
import 'package:waya/utils/color_loader.dart';
import 'package:waya/src/views/controller.dart';
import 'package:waya/src/views/intersit.dart';

import 'src/views/layout/agora-rtc.dart';
import 'src/views/layout/auth/login.dart';
import 'src/views/layout/social/calls/providers/callController.dart';
import 'src/views/layout/social/chat/providers/ChatListController.dart';
import 'src/views/layout/social/contacts/provider/contactsController.dart';
import 'utils/margin_utils.dart';
import 'utils/persistence.dart';
import 'package:get/get.dart';

BuildContext contextMain;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Widget _buildDialog(BuildContext context, Map<String, dynamic> item) {
  var message = MessageItemModel.fromJson(json.decode(
      item['notification']['body'].toString().split(':').sublist(1).join(':')));
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

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CallController()),
        ChangeNotifierProvider(builder: (_) => ContactsController()),
        ChangeNotifierProvider(builder: (_) => ChatListController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Waya PayChat',
        navigatorKey: Get.key,
        theme: ThemeData(
            brightness: Brightness.light,
            accentColor: Color(0xFFEF6C00),
            fontFamily: 'ProductSans',
            primaryColor: Colors.white),
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

// SingleTickerProviderStateMixin is used for animation
class SplashState extends State<Splash> {
  @override
  void initState() {
    setState(() {
      contextMain = context;
    });
    super.initState();
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: null,
        body: new Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              customYMargin(70),
              Image.asset(
                'assets/images/logo.png',
                scale: 2,
              ),
              SizedBox(height: 30.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height * 0.55),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/splash.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new ColorLoader(
                        radius: 20, dotRadius: 5, color: Colors.white),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _loadPref() async {
    //eraseAll();
    await new Future.delayed(const Duration(seconds: 7));
    GetProfileData _data = await getProfileData();

    if (_data != null) {
      if ((await getItemData(key: 'add_card')) != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Controller(
              getProfileData: _data,
            ),
          ),
        );
      } else {
        saveItem(key: 'add_card', item: 'true');

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Controller(
              getProfileData: _data,
            ),
          ),
        );
      }
    } else {
      if ((await getItemData(key: 'notFirstTime')) != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
              loginData: _data?.loginData,
            ),
          ),
        );
      } else {
        saveItem(key: 'notFirstTime', item: 'true');
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Intersit(),
          ),
        );
      }
    }
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}
