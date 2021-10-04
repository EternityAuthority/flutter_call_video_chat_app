/* import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import '../intersitCall.dart';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CallSample extends StatefulWidget {
  final String ip;

  CallSample({Key key, @required this.ip}) : super(key: key);

  @override
  _CallSampleState createState() =>
      new _CallSampleState(serverIP: '192.168.8.102');
}

class _CallSampleState extends State<CallSample> {
  Signaling _signaling;
  Widget currentScreen;
  final String serverIP;
  String _displayName =
      Platform.localHostname + '(' + Platform.operatingSystem + ")";
  List<dynamic> _peers;

  var _selfId;
  bool _inCalling = false, isCallAnswered = false;

  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  String selfId;
  List peers;

  _CallSampleState({Key key, @required this.serverIP});

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect();
    setState(() {
      currentScreen = Scaffold(body: Center(child: Text('WAITING FOR CALL')));
    });
  }

  @override
  deactivate() {
    super.deactivate();

    _localRenderer.dispose();
    _remoteRenderer.dispose();
    if (_signaling != null) _signaling.close();
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == selfId);
    print(peer['id']);
    /*  return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + '[Your self]'
            : peer['name'] + '[' + peer['user_agent'] + ']'),
        onTap: null,
        trailing: new SizedBox(
            width: 100.0,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: () => _invitePeer(context, peer['id'], false),
                    tooltip: 'Video calling',
                  ),
                  IconButton(
                    icon: const Icon(Icons.screen_share),
                    onPressed: () => _invitePeer(context, peer['id'], true),
                    tooltip: 'Screen sharing',
                  )
                ])),
        subtitle: Text('id: ' + peer['id']),
      ),
      Divider()
    ]);
   */
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = new Signaling(serverIP, _displayName,)..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            /*  this.setState(() {
              _inCalling = true;
            }); */

            print('incall');
            break;
          case SignalingState.CallStateBye:
            print('bye');
            // FlutterRingtonePlayer.stop();
            setState(() {
              currentScreen =
                  Scaffold(body: Center(child: Text('WAITING FOR CALL')));
            });
            break;
          case SignalingState.CallStateInvite:
            print('WAYAlog: invited to call');
            break;
          case SignalingState.CallStateConnected:
            print('WAYAlog: invited to calljjl');
            //  FlutterRingtonePlayer.stop();
            setState(() {
              currentScreen = _buildCall();
            });
            print('WAYAlog: answered call');
            break;
          case SignalingState.CallStateRinging:
            FlutterRingtonePlayer.playRingtone(looping: true);
            setState(() {
              currentScreen = IntersitCall(_setCallAnswered, _hangUp);
            });
            print('WAYAlog: phone ringing');
            break;
          case SignalingState.ConnectionClosed:
            print('WAYAlog: answred closed');
            break;
          case SignalingState.ConnectionError:
            print('WAYAlog: connection error');
            break;
          case SignalingState.ConnectionOpen:
            print('WAYAlog: open call');
            break;
         // case SignalingState.CallStateAnswered:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  initRenderers() async {
    setState(() {
      peers = peers;
      selfId = selfId;
    });
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _invitePeer(context, peerId, useScreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling.invite(peerId, 'video', useScreen);
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
      print('bye');
      /*  setState(() {
        currentScreen = Scaffold(body: Center(child: Text('WAITING FOR CALL')));
      }); */
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {}

  setInCalling(bool v) {
    setState(() {
      _inCalling = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentScreen;
  }

  _setCallAnswered() {
    if (_signaling != null) {
      try {
        if (_signaling.onStateChange != null) {
          print('lll');
          //answered
        //  _signaling.controller.add('true');
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      _signaling.bye();
    }
  }

  _buildCall() => Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                      elevation: 5,
                      child: const Icon(Icons.rotate_90_degrees_ccw,
                          color: Colors.blueGrey),
                      backgroundColor: Colors.white,
                      onPressed: () => _switchCamera()),
                  FloatingActionButton(
                    elevation: 5,
                    onPressed: () => _hangUp(),
                    tooltip: 'Hangup',
                    child: new Icon(Icons.close),
                    backgroundColor: Colors.pink,
                  ),
                  FloatingActionButton(
                    elevation: 5,
                    child: const Icon(
                      Icons.mic_off,
                    ),
                    onPressed: () => _muteMic(),
                    backgroundColor: Colors.black26, //_muteMic,
                  )
                ]),
          )),
      body: OrientationBuilder(builder: (context, orientation) {
        return new Container(
          child: new Stack(children: <Widget>[
            new Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: new Container(
                  width: MediaQuery.of(context).size.height,
                  height: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(child: new RTCVideoView(_remoteRenderer)),
                    ],
                  ),
                  decoration: new BoxDecoration(color: Colors.black54),
                )),
            new Positioned(
              left: 0.0,
              right: 8.0,
              bottom: 140.0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: new Container(
                  margin: EdgeInsets.all(20),
                  child: new RTCVideoView(_localRenderer),
                  width: orientation == Orientation.portrait ? 110.0 : 170.0,
                  height: orientation == Orientation.portrait ? 170.0 : 110.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: Colors.deepOrange.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            /*  new Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              top: 80,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    new Text('Martins Victor',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 19)),
                    Container(
                      height: 5,
                    ),
                    new Text('2 mins 30 secs',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
           */
          ]),
        );
      }));
}
 */