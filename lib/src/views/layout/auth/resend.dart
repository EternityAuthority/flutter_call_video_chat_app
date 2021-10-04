import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:waya/src/functions/auth/resendFunc.dart';
import 'package:waya/src/views/layout/auth/login.dart';
import 'package:waya/utils/color_utils.dart';
import 'package:waya/utils/margin_utils.dart';

class ResendOTP extends StatefulWidget {
  final String phone;
  // In the constructor, require a Chat
  ResendOTP({Key key, @required this.phone}) : super(key: key);
  _ResendOTPState createState() => _ResendOTPState(phone: phone);
}

class _ResendOTPState extends State<ResendOTP> {
  _ResendOTPState({Key key, String phone});

  final _formKey = GlobalKey<FormState>();
  String phone;
  String countryCode;
  String otp;

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    /*  final verifyBtn = ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => postData(),
        color: ColorUtils.primary,
        textColor: Colors.white,
        child: Text('ResendOTP OTP'),
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
                  image: AssetImage('assets/images/resend.png'),
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
                        "Resend OTP to Phone Number",
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
                          buildPhone(),
                          customYMargin(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 30, bottom: 30),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Go to Login",
                                    style: TextStyle(
                                        color: Color(0xFFEF6C00),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          customYMargin(20),
                          Container(
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : resendButton()),
                        ],
                      )),
                )
              ],
            ),
          )),
    );
  }

  buildPhone() => Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Container(
          // height: 65,
          child: TextFormField(
            validator: (value) {
              if (value.length >= 10) {
                setState(() {
                  phone = '${countryCode ?? "+234"}' + value;
                });
                return null;
              } else if (value.isEmpty) {
                return "This field can't be left empty";
              } else {
                return "Please enter a valid Phone Number";
              }
            },
            style: TextStyle(color: Colors.black, fontSize: 20),
            onFieldSubmitted: (val) {
              _formKey.currentState.validate();
            },
            onEditingComplete: () {
              setState(() {});
            },
            decoration: InputDecoration(
                //labelText: 'Mobile Number',
                hintText: '100 0000 000',
                prefix: new CountryCodePicker(
                  onChanged: _onCountryChange,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'NG',
                  textStyle: TextStyle(fontSize: 20),
                  favorite: ['+234', 'NG'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country na
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
                contentPadding: EdgeInsets.all(18.0),
                labelText: 'Mobile Number',
                labelStyle: TextStyle(fontSize: 17.8)),
            keyboardType: TextInputType.number,
          ),
        ),
      );

  void _onCountryChange(CountryCode val) {
    setState(() => countryCode = val.dialCode);
    // print("New Country selected: " + countryCode.toString());
  }

  resendButton() => ButtonTheme(
        minWidth: 150.0,
        height: 50.0,
        child: RaisedButton(
          onPressed: () => _sendOTP(),
          color: ColorUtils.primary,
          textColor: Colors.white,
          child: Text('Re-Send OTP'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      );

  _sendOTP() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
        });

        await ResendOTPFunc.postData(phone, context).whenComplete(() async {
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
