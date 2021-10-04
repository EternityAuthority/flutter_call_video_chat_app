import 'package:flutter/material.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/src/functions/fcm/cloudMessagingServices.dart';

class InitCall extends StatefulWidget {
  final User contact;
  final Function hangUp;

  InitCall(
    this.hangUp, {
    Key key,
    @required this.contact,
  }) : super(key: key);

  _InitCallState createState() => _InitCallState();
}

class _InitCallState extends State<InitCall>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  AnimationController _animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    //set calling notif here
    fireCallNotification();

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

  void fireCallNotification() async {
    var callState = await CloudMessagingServices.sendCallNotif(
      context,
      callType: 'video',
      receiverId: widget.contact.id,
    );

    print('response from call notif sent: $callState');
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
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  AnimatedBuilder(
                    builder: (BuildContext context, Widget child) {
                      return Transform.scale(
                        scale: animation.value,
                        alignment: FractionalOffset.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: FloatingActionButton(
                              heroTag: null,
                              elevation: 5,
                              child: const Icon(
                                Icons.call_end,
                              ),
                              backgroundColor: Colors.red,
                              onPressed: () {
                                widget.hangUp();
                              }),
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
              bottom: 0.0,
              top: 200,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    new Text(widget.contact.fullName ?? '',
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

  String initials(firstName, lastName) {
    return ((firstName.isNotEmpty == true ? firstName[0] : "") +
            (lastName?.isNotEmpty == true ? lastName[0] : ""))
        .toUpperCase();
  }
}
