import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:waya/src/views/layout/social/calls/providers/callController.dart';
import 'package:waya/utils/constants.dart';

class AgoraCallInterface extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String fullName;
  final String channelId;
  // final Function hangUp;
  final bool isVideo;

  /// Creates a call page with given channel name.
  const AgoraCallInterface({
    Key key,
    @required this.channelId,
    @required this.fullName,
    // @required this.hangUp,
    this.isVideo = false,
  }) : super(key: key);

  @override
  _AgoraCallInterfaceState createState() => _AgoraCallInterfaceState();
}

class _AgoraCallInterfaceState extends State<AgoraCallInterface> {
  bool isOnCall = false;
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool onSpeaker = false;

  CallController callController;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (AGORA_APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":640,\"height\":480,\"frameRate\":30,\"bitRate\":140}}''');

    await AgoraRtcEngine.joinChannel(null, widget.channelId, null, 0);

    // if (!widget.isReceiver) {
    //   //
    //   fireCallNotification();
    // } else {}
  }

  // void fireCallNotification() async {
  //   var callState = await CloudMessagingServices.sendCallNotif(context,
  //       receiverId: widget.receiverId,
  //       callType: widget.isVideo ? 'video' : 'voice');

  //   print('response from call notif sent: $callState');
  // }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(AGORA_APP_ID);
    if (widget.isVideo) await AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.setEnableSpeakerphone(onSpeaker);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);

        //user has joined call
        if (_users.length > 1) {
          isOnCall = true;
        }
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callController.hangUp();
    //Navigator.pop(context);//
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  void _onToggleSpeaker() {
    setState(() {
      onSpeaker = !onSpeaker;
    });
    AgoraRtcEngine.setEnableSpeakerphone(onSpeaker);
  }

  _buildCallingScreen(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: FloatingActionButton(
                        heroTag: null,
                        elevation: 5,
                        child: const Icon(
                          Icons.call_end,
                        ),
                        backgroundColor: Colors.red,
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        }),
                  ),
                ]),
          )),
      body: OrientationBuilder(builder: (context, orientation) {
        return new Container(
          child: new Stack(children: <Widget>[
            new Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              top: 200,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    new Text(widget.fullName ?? '',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 26)),
                    Container(
                      height: 40,
                    ),
                    new Text('Calling...',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 19)),
                  ],
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }

  _buildConnectingScreen() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () => _onCallEnd(context),
        tooltip: 'Hangup',
        child: new Icon(Icons.close),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Stack(children: <Widget>[
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
                    Expanded(child: _getRenderViews()[0]),
                  ],
                ),
                decoration: new BoxDecoration(color: Colors.black54),
              )),
          new Positioned(
            left: 0.0,
            right: 8.0,
            bottom: 140.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Text('Connecting..',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(.5),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _buildVoiceCallScreen() {
    return new Container(
      child: new Stack(children: <Widget>[
        new Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: new RTCVideoView(_remoteRenderer),
              decoration: BoxDecoration(color: Colors.white),
              //decoration: new BoxDecoration(color: Colors.black54),
            )),
        new Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          top: 200,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                ),
                new Text(widget.fullName ?? '',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 26)),
                Container(
                  height: 40,
                ),
                new Text('In Call',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 19)),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final views = _getRenderViews();
    return _getRenderViews().length <= 1
        ? _buildConnectingScreen()
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: new SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.isVideo
                            ? FloatingActionButton(
                                mini: true,
                                elevation: 5,
                                child: const Icon(Icons.rotate_90_degrees_ccw,
                                    color: Colors.blueGrey),
                                backgroundColor: Colors.white,
                                onPressed: _onSwitchCamera)
                            : SizedBox(),
                        FloatingActionButton(
                          elevation: 5,
                          onPressed: () => _onCallEnd(context),
                          tooltip: 'Hangup',
                          child: new Icon(Icons.close),
                          backgroundColor: Colors.pink,
                        ),
                        FloatingActionButton(
                          mini: true,
                          elevation: 5,
                          child: Icon(
                            muted ? Icons.mic : Icons.mic_off,
                            color: muted ? Colors.white : Colors.blueAccent,
                          ),
                          onPressed: _onToggleMute,
                          backgroundColor: muted
                              ? Colors.blueAccent
                              : Colors.white, //_muteMic,
                        ),
                        FloatingActionButton(
                          mini: true,
                          elevation: 5,
                          child: Icon(
                            Icons.speaker_phone,
                            color: Colors.black,
                          ),
                          onPressed: _onToggleSpeaker,
                          backgroundColor: onSpeaker
                              ? Colors.blueAccent
                              : Colors.white, //_muteMic,
                        )
                      ]),
                )),
            body: OrientationBuilder(builder: (context, orientation) {
              return widget.isVideo
                  ? new Container(
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
                                  Expanded(child: _getRenderViews()[1]),
                                ],
                              ),
                              decoration:
                                  new BoxDecoration(color: Colors.black54),
                            )),
                        new Positioned(
                          left: 0.0,
                          right: 8.0,
                          bottom: 140.0,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: new Container(
                              margin: EdgeInsets.all(20),
                              child: _getRenderViews()[0],
                              width: orientation == Orientation.portrait
                                  ? 110.0
                                  : 170.0,
                              height: orientation == Orientation.portrait
                                  ? 170.0
                                  : 110.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.deepOrange.withOpacity(.5),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  : _buildVoiceCallScreen();
            }));
  }
}
