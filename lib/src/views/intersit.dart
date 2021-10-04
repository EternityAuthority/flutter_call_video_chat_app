import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:undraw/undraw.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/src/views/layout/auth/signup.dart';
import 'package:waya/utils/color_utils.dart';
import 'package:waya/utils/margin_utils.dart';

import 'layout/auth/resend.dart';

class Intersit extends StatefulWidget {
  @override
  IntersitState createState() => new IntersitState();
}

// SingleTickerProviderStateMixin is used for animation
class IntersitState extends State<Intersit>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
  
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            height: 230,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(220, 60),
                  bottomRight: Radius.elliptical(220, 60),
                ),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/bg.png'))),
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 88.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width * 0.55,
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              offset: Offset(0, 10),
                              spreadRadius: -13,
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 18,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(300),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/appicon.png'))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    customYMargin(20),
                    // Hero(tag: "logo", child: Container(height: 50, child: logo)),

                    new Center(
                      child: new Text("Welcome to Waya",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    customYMargin(10),
                    new Center(
                      child: new Text(
                          "Need an easy way of doing transcations?\nLet Us Help",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[350],
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ),
                    customYMargin(40),
                    buildSignup(context),
                    customYMargin(20),
                    buildLogin(context),
                    customYMargin(20),
                    buildOTP(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    /* return new Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Center(
           
          ),
        ));
  */
  }

  buildSignup(BuildContext context) => ButtonTheme(
        minWidth: 230.0,
        height: 50.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Signup(),
              ),
            );
          },
          color: ColorUtils.primary,
          textColor: Colors.white,
          child: Text('Create a new Account'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );

  buildLogin(BuildContext context) => ButtonTheme(
        minWidth: 230.0,
        height: 50.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(
                  loginData: null,
                ),
              ),
            );
          },
          color: Colors.white,
          textColor: ColorUtils.primary,
          child: Text('Login to Account'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );

  buildOTP(BuildContext context) => ButtonTheme(
        minWidth: 230.0,
        height: 50.0,
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.white,
          ),
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResendOTP(
                    phone: null,
                  ),
                ),
              );
            },
            //highlightedBorderColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: Colors.white,
            textColor: Colors.black54,
            child: Text('Resend OTP'),
          ),
        ),
      );
}
