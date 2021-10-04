import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:waya/models/auth/login.dart';
import 'package:waya/src/functions/auth/loginFunc.dart';
import 'package:waya/utils/color_utils.dart';
import 'package:waya/utils/margin_utils.dart';
import 'package:waya/utils/persistence.dart';
import 'package:permission_handler/permission_handler.dart';

import 'resetPassword.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  final LoginModel loginData;

  Login({Key key, this.loginData}) : super(key: key);
  @override
  _LoginState createState() => new _LoginState(loginData: loginData);
}

class _LoginState extends State<Login> {
  LoginModel loginData;
  _LoginState({Key key, @required this.loginData});

  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumTEC = new TextEditingController();
  String phone;
  String password;
  String countryCode;

  var isLoading = false;

  @override
  void initState() {
    _loadData();
    _requestPerm();
    super.initState();
  }

  loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: ButtonTheme(
          minWidth: 150.0,
          height: 50.0,
          child: Container(
              height: 55,
              width: double.infinity,
              child: RaisedButton(
                color: ColorUtils.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () => postData(),
              ))),
    );
  }

  merchantButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 188.0, top: 30),
      child: ButtonTheme(
          minWidth: 150.0,
          height: 60.0,
          child: Container(
              height: 55,
              width: double.infinity,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(19),
                )),
                color: ColorUtils.primary,
                textColor: ColorUtils.primary,
                highlightedBorderColor: ColorUtils.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    customXMargin(20),
                    Text(
                      'I\'m a Merchant',
                      style: TextStyle(
                          color: ColorUtils.primary,
                          fontSize: 17,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                onPressed: () {},
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Theme(
          data: ThemeData(
            fontFamily: 'ProductSans',
            primaryColor: Color(0xFFEF6C00),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          customYMargin(20),
                          loginData?.data?.fullName != null
                              ? Text(
                                  'Welcome Back ${loginData?.data?.fullName != null ? ',' : ''}',
                                  style: TextStyle(
                                      color: ColorUtils.primary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                )
                              : Container(),
                          customYMargin(10),
                          loginData?.data != null
                              ? Text(
                                  '${loginData?.data?.fullName?.split(' ')[0] ?? ''}',
                                  style: TextStyle(
                                      color: ColorUtils.primary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                )
                              : Container(),
                        ],
                      ),
                      customXMargin(20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          /*  boxShadow: [
                            new BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: -13,
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 28,
                            ),
                          ], */
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/logo.png',
                          scale: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                buildPhone(),
                customYMargin(20),
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                  child: Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value.isNotEmpty && value.length >= 8) {
                          setState(() {
                            password = value;
                          });
                          return null;
                        } else if (value.isEmpty) {
                          return "This field can't be left empty";
                        } else {
                          return "Password is Invalid";
                        }
                      },
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18.0),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 17.8)),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                  ),
                ),
                customYMargin(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35, top: 30, bottom: 40),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  ],
                ),
                customYMargin(10),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : loginButton(),
                /* merchantButton(),
                customYMargin(20), */
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        right: 30,
                      ),
                      child: Container(
                        height: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "New User? Signup",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  HMarginUtils.mg10,
                                  Text(
                                    "Here",
                                    style: TextStyle(color: Color(0xFFEF6C00)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            controller: phoneNumTEC,
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

  postData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await LoginFunc.postData(password, phone.replaceAll(' ', ''), context);
      setState(() {
        isLoading = false;
      });
      _formKey.currentState.reset();
    }
  }

  void _loadData() async {
    GetProfileData _data = await getProfileData();
    if (_data?.loginData != null) {
      setState(() {
        phoneNumTEC.text = _data?.loginData?.data?.phone?.substring(4);
      });
    }

    /*  if (loginData != null)
      setState(() => phoneNumTEC.text = loginData?.data?.phone);
   */
  }

  void _requestPerm() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted) {
      /* Map<PermissionGroup, PermissionStatus> permissions = */
      await PermissionHandler().requestPermissions([
        PermissionGroup.contacts,
        PermissionGroup.sms,
        PermissionGroup
            .storage, /* 
        PermissionGroup.microphone,
        PermissionGroup.camera */
      ]);
    }
  }
}
