import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:waya/src/functions/auth/verifyFunc.dart';
import 'package:waya/utils/margin_utils.dart';

import 'login.dart';
import 'resend.dart';

class Verify extends StatefulWidget {
  final String phone, password;
  Verify({
    Key key,
    @required this.phone,
    this.password,
  }) : super(key: key);
  _VerifyState createState() => _VerifyState(phone: phone);
}

class _VerifyState extends State<Verify> {
  final String phone;
  _VerifyState({Key key, @required this.phone});

  final _formKey = GlobalKey<FormState>();
  String otp;

  var isLoading = false;

  final SmsListener smsListener = SmsListener(
      from: '92927292428', // address that the message will come from
      formatBody: (String body) {
        String codeRaw = body.split(": ")[1];
        List<String> code = codeRaw.split("-");
        return code.join(); // 341430
      });

  Widget pinViewWithSms(BuildContext context) => PinView(
      count: 6,
      obscureText: true,
      autoFocusFirstField: true,
      enabled: true, //// listener we created,
      submit: (String pin) {
        // when the message comes, this function
        // will trigger
        setState(() {
          isLoading = true;
          otp = pin;
        });
        _sendOTP();
      });

  @override
  Widget build(BuildContext context) {
    /*  final verifyBtn = ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => postData(),
        color: ColorUtils.primary,
        textColor: Colors.white,
        child: Text('Verify OTP'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    ); */
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
          data: ThemeData(
            primaryColor: Color(0xFFEF6C00),
          ),
          child: Center(
            child: ListView(
              children: <Widget>[
                customYMargin(30),
                Image(
                  image: AssetImage('assets/images/otp.png'),
                  width: 240.0,
                ),
                customYMargin(10),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Verify account with OTP",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                customYMargin(20),
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          customYMargin(30),
                          pinViewWithSms(context),
                          customYMargin(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 30, bottom: 30),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResendOTP(
                                        phone: phone,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                        color: Color(0xFFEF6C00),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          customYMargin(20),
                          buildBottomLink(context),
                          customYMargin(30),
                          Container(
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()),
                        ],
                      )),
                )
              ],
            ),
          )),
    );
  }

  buildBottomLink(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 30),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(
                    loginData: null,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Go back to",
                  style: TextStyle(color: Colors.grey),
                ),
                HMarginUtils.mg10,
                Text(
                  "Login",
                  style: TextStyle(color: Color(0xFFEF6C00)),
                ),
              ],
            ),
          ),
        ),
      );

  _sendOTP() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
        });

        await VerifyFunc.postData(phone, otp, context, widget.password)
            .whenComplete(() async {
          // await new Future.delayed(const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }
}
