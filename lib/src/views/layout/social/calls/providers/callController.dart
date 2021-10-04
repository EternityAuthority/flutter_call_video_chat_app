import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:waya/models/social/call/webrtcUser.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/src/functions/fcm/cloudMessagingServices.dart';
import 'package:waya/src/views/controller.dart';
import 'package:waya/src/views/layout/agora-rtc.dart';
import 'package:waya/src/views/layout/social/chat/exploreChats.dart';
import 'package:waya/utils/persistence.dart';

import '../initCall.dart';
import '../intersitCall.dart';
import '../call_sample/signaling.dart';

class CallController extends ChangeNotifier {
  StreamController<String> streamController =
      new StreamController<String>.broadcast();

  WebRTCUsers _onlineUsers;
  WebRTCUsers get onlineUsers => _onlineUsers;

  var _data;
  get data => _data;

  Signaling _signaling;

  Signaling get signaling => _signaling;

  final String serverIP = '138.197.67.90';

  /*  String _displayName =
      Platform.localHostname + '(' + Platform.operatingSystem + ")";
 */
  bool _inCalling = false;
  bool get inCalling => _inCalling;

  bool _isVideo = false;
  bool get isVideo => _isVideo;

  bool _isCallAnswered = false;
  bool get isCallAnswered => _isCallAnswered;

  int _receiverId;
  int get receiverId => _receiverId;

  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();

  RTCVideoRenderer get localRenderer => _localRenderer;

  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  String _selfId;
  String get selfId => _selfId;

  List<dynamic> _peers;
  List get peers => _peers;

  Widget _currentView;
  Widget get currentView => _currentView;

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.grey,
  );

  Widget appBarTitle = new Text(
    "Chats",
    style: new TextStyle(color: Colors.black),
  );

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  GetProfileData _userData;
  GetProfileData get userData => _userData;

  List<Widget> _currentScreen = [];
  List<Widget> get currentScreen => _currentScreen;

  var navItems = [
    BottomNavyBarItem(
      icon: Icon(Icons.chat_bubble),
      title: Text('Chats'),
      inactiveColor: Colors.grey[600],
      activeColor: Colors.red,
    ),
    BottomNavyBarItem(
        icon: Icon(Icons.people),
        title: Text('Contacts'),
        inactiveColor: Colors.grey[600],
        activeColor: Colors.orange),
    BottomNavyBarItem(
        icon: Icon(Icons.navigation),
        title: Text('Discover'),
        inactiveColor: Colors.grey[600],
        activeColor: Colors.green),
    BottomNavyBarItem(
        icon: Icon(Icons.person),
        title: Text('Profile'),
        inactiveColor: Colors.grey[600],
        activeColor: Colors.blueAccent),
    BottomNavyBarItem(
        icon: Icon(Icons.attach_money),
        title: Text('Waya Pay'),
        inactiveColor: Colors.grey[600],
        activeColor: Colors.amber),
  ];

  BuildContext _context;
  BuildContext get context => _context;

  String _callerName;
  String get callerName => _callerName;

  set callerName(val) {
    _callerName = val;
    notifyListeners();
  }

  set context(_) {
    _context = _;
    notifyListeners();
  }

  set currentScreen(_) {
    _currentScreen = _;
    notifyListeners();
  }

  set userData(_) {
    _userData = _;
    notifyListeners();
  }

  set localRenderer(_) {
    _localRenderer = _;
    notifyListeners();
  }

  set remoteRenderer(_) {
    _remoteRenderer = _;
    notifyListeners();
  }

  set signaling(_) {
    _signaling = _;
    notifyListeners();
  }

  set selfId(_) {
    _selfId = _;
    notifyListeners();
  }

  set inCalling(_) {
    _inCalling = _;
    notifyListeners();
  }

  set peers(_) {
    _peers = _;
    notifyListeners();
  }

  set currentIndex(_) {
    _currentIndex = _;
    notifyListeners();
  }

  set isCallAnswered(_) {
    _isCallAnswered = _;
    notifyListeners();
  }

  set receiverId(val) {
    _receiverId = val;
    notifyListeners();
  }

  set isVideo(_) {
    _isVideo = _;
    notifyListeners();
  }

  set currentView(_) {
    _currentView = _;
    notifyListeners();
  }

  set data(val) {
    _data = val;
    notifyListeners();
  }

  set onlineUsers(val) {
    _onlineUsers = val;
    notifyListeners();
  }

  void connect(context, String userId, String fullName) async {
    if (_signaling == null) {
      _signaling = new Signaling(serverIP, fullName, userId, context)
        ..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            _inCalling = true;

            print('incall');
            break;
          case SignalingState.CallStateBye:
            FlutterRingtonePlayer.stop();
            print('Byebye');
            // _localRenderer.srcObject = null;
            // _remoteRenderer.srcObject = null;

            _currentView = controllerView(_currentIndex, ctx: context);
            notifyListeners();

            break;
          case SignalingState.CallStateInvite:
            print('WAYAlog: invited to call');

            //fire notification
            fireCallNotification(
                    this._receiverId, this._isVideo ? 'video' : 'voice')
                .then((res) {
              currentView = InitCall(
                this.hangUp,
                contact: new User(fullName: _callerName),
              );
            });

            break;
          case SignalingState.CallStateConnected:
            print('WAYAlog: call to connected');
            FlutterRingtonePlayer.stop().then((_) {
              currentView = AgoraCallInterface(
                isVideo: _isVideo,
                fullName: _callerName,
                channelId: _signaling.sessionId,
                // hangUp: this.hangUp,
              );
            });

            print('WAYAlog: answered call');
            break;
          case SignalingState.CallStateRinging:
            FlutterRingtonePlayer.playRingtone(looping: true);

            currentView = IntersitCall(
              setCallAnswered,
              hangUp,
              fullName: _callerName,
              isVideo: _isVideo,
            );

            print('WAYAlog: phone ringing');
            break;
          case SignalingState.ConnectionClosed:
            print('WAYAlog: answred closed');
            currentView = _currentView;
            this.hangUp();
            break;
          case SignalingState.ConnectionError:
            print('WAYAlog: connection error');
            break;
          case SignalingState.ConnectionOpen:
            print('WAYAlog: open call');

            break;
            //case SignalingState.CallStateAnswered:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        _selfId = event['self'];
        _peers = event['peers'];
      });

      // _signaling.onLocalStream = ((stream) {
      //   _localRenderer.srcObject = stream;
      // });

      // _signaling.onAddRemoteStream = ((stream) {
      //   _remoteRenderer.srcObject = stream;
      // });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });

      // invitePeer(context, '113578', false);
    }
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  invitePeer(context, peerId, useScreen, _namem, {bool isVideo = false}) async {
    _callerName = _namem;
    notifyListeners();
    if (_signaling != null && peerId != _selfId) {
      print('invited: $peerId');
      _signaling.invite(peerId, isVideo ? 'video' : 'audio', useScreen);
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {}

  setInCalling(bool v) {
    _inCalling = v;
  }

  fireCallNotification(int receiver, String callType) async {
    var res = CloudMessagingServices.sendCallNotif(context,
        receiverId: receiver, callType: callType);
  }

  setCallAnswered() {
    if (_signaling != null) {
      try {
        if (_signaling.onStateChange != null) {
          streamController.add('answer');
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      _signaling.bye();
    }
  }

  controllerView(i, {ctx}) {
    _context = ctx;
    return new Scaffold(
      appBar: navItems[i].title.data != "Chats"
          ? new AppBar(
              title: navItems[i].title,
              elevation: 0,
              centerTitle: true,
              // actions: <Widget>[],
            )
          : new AppBar(
              elevation: 0,
              centerTitle: true,
              title: appBarTitle,
              actions: <Widget>[
                  new IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => ExploreChats(),
                        ),
                      );
                    },
                  ),
                ]),
      body: currentScreen[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        currentIndex: _currentIndex,
        onItemSelected: (i) {
          _currentIndex = i;
          // print(i);
          _currentView = controllerView(_currentIndex, ctx: context);
          notifyListeners();
        },
        items: navItems,
      ),
    );
  }

  hangUp() {
    if (_signaling != null) {
      _signaling.bye();
      _signaling.closeConnectionState();
      // Navigator.pop(context);
      /*  setState(() {
        currentScreen = Scaffold(body: Center(child: Text('WAITING FOR CALL')));
      }); */
    }
  }
}
