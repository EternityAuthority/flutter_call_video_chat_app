import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:provider/provider.dart';
import 'package:waya/src/views/layout/social/calls/providers/callController.dart';
import 'package:waya/src/views/layout/social/chat/Chats.dart';
import 'package:waya/src/views/layout/social/contacts/Contacts.dart';
import 'package:waya/utils/persistence.dart';
import 'package:waya/utils/singleton/notificationsHandler.dart';

class Controller extends StatefulWidget {
  final GetProfileData getProfileData;

  Controller({Key key, this.getProfileData}) : super(key: key);

  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  CallController controller;

  @override
  void initState() {
    _loadData();
    setData();
    setState(() {
      contextMain = context;
    });
    NotificationHandler(controller).initializeFcmNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallController>(builder: (context, counter, _) {
      controller = Provider.of<CallController>(context);
      return controller?.currentView ?? Scaffold();
    });
  }

  void _loadData() async {
    await Future.delayed(Duration(milliseconds: 600));

    controller.currentIndex = 0;
    controller.userData = controller.userData;

    controller.currentScreen = [ChatsList(), ContactsList()];

    controller.currentView =
        controller.controllerView(controller.currentIndex, ctx: context);

    //  controller.initRenderers(); //this disables flutter_webrtc renders

    //this connects app user to webrtc server
    controller.connect(
        context,
        '${widget.getProfileData.profileData.data.userDetails.id}',
        '${widget.getProfileData.profileData.data.userDetails.fullName}');
    controller.userData = await getProfileData();

    if (controller.userData != null && controller.userData.loginData != null) {}
  }

  void setData() {
    if (controller != null) {
      controller.currentView =
          controller.controllerView(controller.currentIndex, ctx: context);
    }
  }

  @override
  void dispose() {
    if (controller.signaling != null) controller.signaling.close();
    // controller.localRenderer.dispose();
    // controller.remoteRenderer.dispose();
    super.dispose();
  }
}

class BuildCall extends StatefulWidget {
  const BuildCall({
    Key key,
    @required this.context,
    @required RTCVideoRenderer remoteRenderer,
    @required RTCVideoRenderer localRenderer,
    @required this.switchCamera,
    @required this.hangUp,
    @required this.muteMic,
    @required this.isVideo,
    @required this.fullName,
  })  : _remoteRenderer = remoteRenderer,
        _localRenderer = localRenderer,
        super(key: key);

  final BuildContext context;
  final RTCVideoRenderer _remoteRenderer;
  final RTCVideoRenderer _localRenderer;
  final Function switchCamera, hangUp, muteMic;
  final bool isVideo;
  final String fullName;

  @override
  _BuildCallState createState() => _BuildCallState();
}

class _BuildCallState extends State<BuildCall> {
  @override
  void dispose() {
    this.widget.hangUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.isVideo
                        ? FloatingActionButton(
                            heroTag: null,
                            elevation: 5,
                            child: const Icon(Icons.rotate_90_degrees_ccw,
                                color: Colors.blueGrey),
                            backgroundColor: Colors.white,
                            onPressed: () => widget.switchCamera())
                        : SizedBox(),
                    FloatingActionButton(
                      heroTag: null,
                      elevation: 5,
                      onPressed: () => widget.hangUp(),
                      tooltip: 'Hangup',
                      child: new Icon(Icons.close),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      elevation: 5,
                      child: const Icon(
                        Icons.mic_off,
                      ),
                      onPressed: () => widget.muteMic(),
                      backgroundColor: Colors.black26, //_muteMic,
                    )
                  ]),
            )),
        body: OrientationBuilder(builder: (context, orientation) {
          return widget.isVideo
              ? Container(
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
                              Expanded(
                                  child:
                                      new RTCVideoView(widget._remoteRenderer)),
                            ],
                          ),
                          decoration: new BoxDecoration(color: Colors.black87),
                        )),
                    new Positioned(
                      left: 0.0,
                      right: 8.0,
                      bottom: 140.0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: new Container(
                          margin: EdgeInsets.all(20),
                          child: new RTCVideoView(widget._localRenderer),
                          width: orientation == Orientation.portrait
                              ? 110.0
                              : 150.0,
                          height: orientation == Orientation.portrait
                              ? 150.0
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
              : new Container(
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
        }));
  }
}
