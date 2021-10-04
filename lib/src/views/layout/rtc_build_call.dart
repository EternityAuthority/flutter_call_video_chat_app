import 'package:flutter/material.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';

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
