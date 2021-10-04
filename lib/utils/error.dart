
import 'package:flutter/material.dart';

wayaDialog({String title, String content, BuildContext context}){
  print(title);
  showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                      title: new Text( title != null ? title : "Error"),
                      content: new Text("$content"),
                    ));
}