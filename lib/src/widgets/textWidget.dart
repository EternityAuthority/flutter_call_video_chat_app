import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waya/utils/margin_utils.dart';

class TextXField extends StatelessWidget {
  const TextXField(
      {Key key,
      @required this.title,
      @required this.controller,
      this.hint,
      this.isPassword = false,
      this.enabled = false})
      : super(key: key);
  final String title, hint;
  final bool isPassword, enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.grey[400],
        accentColor: Colors.grey[400],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$title',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            customYMargin(10),
            Container(
              height: 50,
              child: TextFormField(
                // maxLines: 1,
                obscureText: isPassword,
                controller: controller,
                enabled: enabled,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(18.0),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.04),
                    border: OutlineInputBorder(),
                    hintText: hint),
                keyboardType:
                    isPassword ? TextInputType.text : TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Password extends StatelessWidget {
  final  controller;
  const Password(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: (value) {
          controller.getPassword();
          print(controller.password);
          if (value == controller.password) {
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Password is Invalid";
          }
        },
        obscureText: true,
        controller: controller.passwordTEC,
        style: TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: UnderlineInputBorder(),
            hintText: 'Password'),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
