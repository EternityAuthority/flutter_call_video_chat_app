import 'package:flutter/material.dart';
import 'package:undraw/undraw.dart';
import 'package:waya/src/functions/auth/resetFunction.dart';
import 'package:waya/utils/margin_utils.dart';
import 'package:waya/utils/validator.dart';


class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  String email;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 220,
              width: 120,
              child: UnDraw(
                color: Colors.orange,
                illustration: UnDrawIllustration.message_sent,
                placeholder: Container(
                  height: 23,
                  width: 23,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: Icon(Icons.error_outline,
                    color: Colors.grey[200], size: 30),
              ),
            ),
            customYMargin(30),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) {
                    if (Validator.isEmail(value)) {
                      setState(() {
                        email = value;
                      });
                      return null;
                    } else if (value.isEmpty) {
                      return "This field can't be left empty";
                    } else {
                      return "Email is Invalid";
                    }
                  },
                  onFieldSubmitted: (val) {
                    _formKey.currentState.validate();
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(18.0),
                      filled: true,
                      fillColor: Colors.blue.withOpacity(0.04),
                      border: OutlineInputBorder(),
                      hintText: 'e.g. example@mail.com'),
                )),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                  'Click the button below to have us send an account reset mail ${email == null ? '' : 'to ' + (email ?? '')} ',
                  style: TextStyle(fontSize: 16.5, height: 1.7)),
            ),
            customYMargin(MediaQuery.of(context).size.height * 0.17),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  !isLoading
                      ? Container(
                          height: 70,
                          child: FlatButton(
                            color: Colors.green[500],
                            child: Text(
                              'Reset Password',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await AccountService.reset(context, email);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ))
                      : Container(
                        height:54,
                        width:54,
                        child:CircularProgressIndicator()),
                ]),

          ],
        ),
      ),
    );
  }
}