import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:undraw/undraw.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/margin_utils.dart';

import 'ChatScreen.dart';
import 'exploreChats.dart';
import 'providers/ChatListController.dart';

class ChatsList extends StatefulWidget {
  ChatsListState createState() => new ChatsListState();
}

class ChatsListState extends State<ChatsList> {
  ChatListController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatListController>(builder: (context, counter, _) {
      controller = Provider.of<ChatListController>(context);
      return new Scaffold(
        key: controller.scaffoldKey,
        body: new Center(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Container(
                height: 87,
                child: TextField(
                  controller: controller.filter,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      controller.isSearching = false;
                    } else {
                      controller.isSearching = true;
                    }
                  },
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Search Name / WayaID',
                      
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.orange,
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            !controller.isLoading
                ? Flexible(child: _buildList())
                : LinearProgressIndicator()
          ]),
        ),
      );
    });
  }

  Widget _buildAvatar(User contact) {
    return new CircleAvatar(
      child: Text(
          initials(
              contact?.fullName.split(' ')[0], contact?.fullName.split(' ')[1]),
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepOrange,
      radius: 30.0,
    );
  }

  _buildText(index) {
    if (controller.listUserContact[index]?.lastMessage != null) {
      if (controller.listUserContact[index].lastMessage
              .contains('**ACCESSCODE101**') ||
          controller.listUserContact[index].lastMessage
              .contains('**PaymentRequest**')) {
        return Text('');
      } else {
        return Text(controller.listUserContact[index].lastMessage);
      }
    }

    return Text(controller.listUserContact[index].lastMessage ?? '');
  }

  Widget _buildList() {
    return controller.listUserContact != null &&
            controller.listUserContact.length > 0
        ? ListView.builder(
            itemCount: controller.listUserContact?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (controller.isSearching) if (controller
                      .listUserContact[index].fullName
                      .toLowerCase()
                      .contains(controller.filter.text.toLowerCase()) ||
                  controller.listUserContact[index].userId
                      .toString()
                      .toLowerCase()
                      .contains(controller.filter.text.toLowerCase()))
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8)
                          .add(EdgeInsets.only(top: index == 0 ? 20 : 0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                            offset: Offset(0, 2),
                            spreadRadius: -12,
                            color: Colors.deepOrange.withOpacity(0.2),
                            blurRadius: 32,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(19),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new ChatScreen(
                                contact: controller.listUserContact[index],
                                getProfileData: controller.profileData,
                              ),
                            ),
                          );
                        },
                        leading:
                            _buildAvatar(controller.listUserContact[index]),
                        title: Text(
                          controller.listUserContact[index].fullName,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        subtitle: _buildText(index),
                      ),
                    ),
                  ),
                );
              else
                return Container();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8)
                    .add(EdgeInsets.only(top: index == 0 ? 20 : 0)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: -12,
                          color: Colors.deepOrange.withOpacity(0.2),
                          blurRadius: 32,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(19),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: new ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new ChatScreen(
                              contact: controller.listUserContact[index],
                              getProfileData: controller.profileData,
                            ),
                          ),
                        );
                      },
                      leading: _buildAvatar(controller.listUserContact[index]),
                      title: Text(
                        controller.listUserContact[index].fullName,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      subtitle: _buildText(index),
                    ),
                  ),
                ),
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: UnDraw(
                    color: Colors.orange,
                    illustration: UnDrawIllustration.begin_chat,
                    placeholder: Container(
                      height: 23,
                      width: 23,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: Icon(Icons.error_outline,
                        color: Colors.grey[200], size: 30),
                  ),
                ),
                customYMargin(5),
                Text(
                  'Opps... You have no chats,\nStart a Chat Now...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                customYMargin(90),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: FlatButton(
                      color: Colors.green[500],
                      child: Text(
                        'Explore',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => ExploreChats(),
                          ),
                        );
                      },
                    ))
              ]);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 1));
    controller.loadData(context);
  }
}
