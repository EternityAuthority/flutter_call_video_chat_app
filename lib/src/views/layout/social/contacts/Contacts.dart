import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/randomColor.dart';

import 'provider/contactsController.dart';

class ContactsList extends StatefulWidget {
  ContactsListState createState() => new ContactsListState();
}

// SingleTickerProviderStateMixin is used for animation
class ContactsListState extends State<ContactsList> {
  ContactsController controller;
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsController>(builder: (context, counter, _) {
      controller = Provider.of<ContactsController>(context);
      return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.grey[50],
          actions: <Widget>[],
          title: Container(
            margin: const EdgeInsets.only(top: 18.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width *
                        (controller.isSearching ? 0.7 : 0.9),
                    child: TextField(
                      onChanged: (value) {
                        if (value != null) {
                          controller.isSearching = true;
                          return null;
                        } else if (value.isEmpty) {
                          controller.isSearching = false;
                        }
                      },
                      controller: controller.searchTEC,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(18.0),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'E.g John Doe'),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 20,
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: <Widget>[
                        controller.isSearching
                            ? IconButton(
                                iconSize: 25,
                                color: Colors.grey,
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  controller.searchTEC.text = '';
                                  controller.isSearching = false;
                                  //controller.notifyListeners();
                                })
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          !controller.isLoading
              ? Flexible(flex: 9, child: _buildList())
              : LinearProgressIndicator()
        ]),
      );
    });
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: controller?.contacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          String phone;

          if (controller.contacts[index].phones.toList().length == 1) {
            phone = controller.contacts[index].phones.toList()[0].value;
          } else if (controller.contacts[index].phones.toList().length > 1) {
            phone = controller.contacts[index]?.phones?.toList()[1].value;
          } else {
            phone = '';
          }

          bool hasAccount = false;
          User currContact;
          if (controller?.usersList != null &&
              controller?.usersList?.data != null)
            for (var item in controller?.usersList?.data) {
              if (item.phone.replaceAll(' ', '') == phone.replaceAll(' ', '')) {
                hasAccount = true;
                currContact = item;
              }
            }
          if (controller.isSearching) {
            if (controller.contacts[index].phones.toList().length == 1 &&
                    controller.contacts[index].phones
                        .toList()[0]
                        .value
                        .contains(controller?.searchTEC?.text?.toLowerCase()) ||
                controller.contacts[index].phones.toList().length == 2 &&
                    controller.contacts[index].phones
                        .toList()[1]
                        .value
                        .contains(controller?.searchTEC?.text?.toLowerCase()) ||
                controller.contacts[index].displayName != null &&
                    (controller.contacts[index].displayName.toLowerCase())
                        .contains(controller?.searchTEC?.text?.toLowerCase()))
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                elevation: 0.2,
                child: new ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  onTap: () {
                    controller.inviteDesicion(index, context);
                  },
                  leading: _buildAvatar(controller.contacts[index]),
                  title: Text(
                    controller.contacts[index]?.displayName ?? '',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(controller.contacts[index].phones
                              .toList()
                              .length >
                          1
                      ? controller.contacts[index].phones.toList()[1].value ??
                          '' +
                              '\n' +
                              controller.contacts[index]?.phones
                                  ?.toList()[0]
                                  .value ??
                          ''
                      : controller.contacts[index].phones.toList().length <= 0
                          ? ''
                          : controller.contacts[index]?.phones
                                  ?.toList()[0]
                                  .value ??
                              ''),
                ),
              );
            else {
              Container(height: 0);
            }
          } else {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              elevation: 0.2,
              child: new ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                leading: _buildAvatar(controller.contacts[index]),
                trailing: Icon(
                  Icons.check_circle,
                  color: hasAccount ? Colors.green : Colors.white,
                ),
                title: Text(
                  controller.contacts[index]?.displayName ?? '',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(controller.contacts[index].phones
                            .toList()
                            .length >
                        1
                    ? controller.contacts[index].phones.toList()[1].value ??
                        '' +
                            '\n' +
                            controller.contacts[index]?.phones
                                ?.toList()[0]
                                .value ??
                        ''
                    : controller.contacts[index].phones.toList().length <= 0
                        ? ''
                        : controller.contacts[index]?.phones
                                ?.toList()[0]
                                .value ??
                            ''),
              ),
            );
          }
          return Container();
        });
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

  Widget _buildAvatar(Contact contact) {
    return WayaAvatar(contact: contact);
  }
}

class WayaAvatar extends StatelessWidget {
  final contact;
  const WayaAvatar({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage:
          contact.avatar != null ? MemoryImage(contact.avatar) : null,
      child: contact.avatar != null
          ? null
          : Text(contact?.initials() ?? '',
              style: TextStyle(color: Colors.white)),
      backgroundColor: randomColor(),
      radius: 30.0,
    );
  }
}
