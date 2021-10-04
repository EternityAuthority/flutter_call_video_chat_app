import 'package:flutter/material.dart';

class IntersitCall extends StatefulWidget {
  final Function answerCall;
  final Function hangUp;
  final String fullName;
  final bool isVideo;

  const IntersitCall(this.answerCall, this.hangUp,
      {this.fullName, @required this.isVideo});

  _IntersitCallState createState() => _IntersitCallState();
}

class _IntersitCallState extends State<IntersitCall>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  AnimationController _animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    final CurvedAnimation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    animation = Tween<double>(begin: 1, end: 1.3).animate(curve);
    if (mounted)
      setState(() {
        _animationController.forward();
      });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
      setState(() {});
    });
    if (mounted) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                      heroTag: null,
                      elevation: 5,
                      child: const Icon(
                        Icons.call_end,
                      ),
                      backgroundColor: Colors.pink,
                      onPressed: () => widget.hangUp()),
                  AnimatedBuilder(
                    builder: (BuildContext context, Widget child) {
                      return Transform.scale(
                        scale: animation.value,
                        alignment: FractionalOffset.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: FloatingActionButton(
                            elevation: 5,
                            heroTag: null,
                            onPressed: () => widget.answerCall(),
                            tooltip: 'Answer',
                            child: new Icon(Icons.call, color: Colors.blueGrey),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    },
                    animation: animation,
                  ),
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
                  margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // child: new RTCVideoView(_remoteRenderer),
                  decoration: BoxDecoration(color: Colors.orange),
                  //decoration: new BoxDecoration(color: Colors.black54),
                )),
            new Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              top: 300,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    new Text(
                        'Incoming ${!widget.isVideo ? 'Voice' : 'Video'} Call...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 19)),
                    Container(
                      height: 20,
                    ),
                    new Text(widget.fullName ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 26)),
                  ],
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
