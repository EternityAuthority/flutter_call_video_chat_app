import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:waya/src/functions/auth/signupFunc.dart';
import 'package:waya/utils/color_utils.dart';
import 'package:waya/utils/constants.dart';
import 'package:waya/utils/margin_utils.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController phoneNumTEC = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String surname, firstname, _state, merchantName, street, city, nationality;
  String phone, countryCode = '+234';
  String password;
  String confirmPassword;

  var isLoading = false, isMerchant = false;

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset('assets/images/logo.png',
        scale: 2.5, color: Colors.orange, colorBlendMode: BlendMode.srcATop);

    return Material(
      color: Colors.white,
      child: Theme(
          data: ThemeData(
            primaryColor: Color(0xFFEF6C00),
          ),
          child: Center(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 140,
                  child: logo,
                ),
                Container(
                  child: Image(
                    image: AssetImage('assets/images/signup.png'),
                  ),
                  width: 190,
                  height: 190,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Register with Mobile Number",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                customYMargin(20),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Switch(
                                activeColor: Colors.deepOrange,
                                onChanged: (bool value) {
                                  setState(() {
                                    isMerchant = value;
                                  });
                                },
                                value: isMerchant,
                              ),
                              customXMargin(10),
                              Text('I am a Merchant')
                            ],
                          ),
                        ),
                        isMerchant ? buildMerchantName() : buildSurname(),
                        customYMargin(30),
                         isMerchant ? buildNationality() : buildFirstName(),
                        isMerchant ? customYMargin(15) : customYMargin(30),
                        buildPhone(),
                        customYMargin(30),
                        isMerchant
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  nationality == 'Nigeria'
                                      ? buildMerchantState()
                                      : buildMerchantStateAlt(),
                                  customYMargin(15),
                                  buildMerchantCity(),
                                  customYMargin(30),
                                  buildMerchantStreet(),
                                  customYMargin(30),
                                ],
                              )
                            : Container(),
                        buildPassword(),
                        customYMargin(30),
                        buildCmPassword(),
                        customYMargin(50),
                        buildLoader(),
                        buildBottomLink(context),
                        customYMargin(30),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  buildBottomLink(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 30, right: 30),
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
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Not a new User? Login",
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
      );

  buildFirstName() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                firstname = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Surname";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'First Name', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  buildSurname() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                surname = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Name";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Surname Name', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  signUpButton() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () => postData(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: ColorUtils.primary,
                  textColor: Colors.white,
                  child: Text('Signup Now'),
                )),
          ),
        ],
      );

  buildLoader() => Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : signUpButton());

  buildCmPassword() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty && value == password) {
              setState(() {
                confirmPassword = value;
              });
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Passwords don't match";
            }
            return null;
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(fontSize: 14)),
          obscureText: true,
        ),
      );

  buildPassword() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
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
              return "Password must be at least 6 characters";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Password', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
      );

  buildPhone() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.length >= 10) {
              setState(() {
                phone = '$countryCode' + value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a valid Phone Number";
            }
          },
          controller: phoneNumTEC,
          style: TextStyle(color: Colors.black, fontSize: 14),
          onFieldSubmitted: (val) {
            _formKey.currentState.validate();
          },
          decoration: InputDecoration(
              //labelText: 'Mobile Number',
              hintText: '8123456789',
              prefix: CountryCodePicker(
                onChanged: _onCountryChange,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'NG',
                favorite: ['+234', 'NG'],
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country na
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
              labelText: 'Mobile Number',
              labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.number,
        ),
      );

  void _onCountryChange(CountryCode val) {
    setState(() => countryCode = val.dialCode);
    // print("New Country selected: " + countryCode.toString());
  }
//Merchant UI Components

  buildMerchantName() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                merchantName = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Surname";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Merchant Name', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  buildMerchantCity() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                city = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Surname";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'City', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  buildMerchantStreet() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                street = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Surname";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Street', labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  buildMerchantState() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: DropdownButton(
          hint: Text('Please choose a state'), // Not necessary for Option 1
          value: _state,
          onChanged: (newValue) {
            setState(() {
              _state = newValue;
            });
          },
          items: Nigerian_States.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        ),
      );

  buildMerchantStateAlt() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _state = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Please enter a Surname";
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'State / Region / Province',
              labelStyle: TextStyle(fontSize: 14)),
          keyboardType: TextInputType.text,
        ),
      );

  buildNationality() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton(
              hint:
                  Text('Please choose a nationality'), // Not necessary for Option 1
              value: nationality,
              onChanged: (newValue) {
                setState(() {
                  nationality = newValue;
                });
              },
              items: Countries.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ],
        ),
      );

  postData() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
        });

        if (isMerchant) {
          if (_state != null && nationality != null) {
            await SignupFunc.registerMerchant(
              context,
              merchantName: merchantName,
              merchantStreet: street,
              merchantCity: city,
              merchantCountry: nationality,
              merchantState: _state,
              password: password,
              phoneNumber: phone,
            );
            setState(() {
              isLoading = false;
            });
          } else {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("Incomplete Form"),
                content: new Text("Please fill all fields appropriately"),
              ),
            );
          }
        } else {
          await SignupFunc.registerNormalUser(
            context,
            fullname: '$surname $firstname',
            password: password,
            phoneNumber: phone,
          ).whenComplete(() async {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }
}
