import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waya/models/users/profileModel.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/margin_utils.dart';

class ChatProfile extends StatefulWidget {
  final User contact;
  final Function sendMessage;
  final UserProfileModel profileData;

  ChatProfile(
      this.sendMessage,{Key key, @required this.contact, this.profileData, })
      : super(key: key);

  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                children: <Widget>[
                  _buildAvatar(),
                  customXMargin(10),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.contact.fullName ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        customYMargin(10),
                        Row(
                          children: <Widget>[
                            Text(
                              'Phone: ' + '${widget.contact.phone}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                            customXMargin(10),
                            Image.asset('assets/images/qrcode.png', scale: 3),
                            customXMargin(10),
                            Icon(Icons.keyboard_arrow_right, color: Colors.grey)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          customYMargin(8),
          Container(
              color: Colors.white,
              child: ListTile(
                onTap: () {
                },
                title: Text('Send Money'),
                leading: Icon(
                  Icons.attach_money,
                  color: Colors.blue,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              )),
          customYMargin(8),
          /*  Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {},
                    title: Text('Request Money'),
                    leading: Icon(Icons.card_giftcard, color: Colors.red),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    title: Text('WayaPay Chat'),
                    leading: Icon(Icons.attach_money),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ))
         */
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return new CircleAvatar(
      child:
          /*  widget.contact.avatar != null
          ? new Image.memory(widget.contact.avatar)
          :  */
          Text(
              widget.contact.fullName.split('')[0] +
                  " " +
                  widget.contact.fullName.split(' ')[1].split('')[0],
              style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepOrange,
      radius: 30.0,
    );
  }
}
