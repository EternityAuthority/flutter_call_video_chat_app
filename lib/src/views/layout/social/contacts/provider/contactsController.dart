import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:waya/src/functions/users/usersList.dart';
import 'package:waya/src/views/layout/social/chat/ChatScreen.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/persistence.dart';

class ContactsController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController searchTEC = new TextEditingController();

  List<Contact> _contacts = new List();
  List<Contact> get contacts => _contacts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSearching = true;
  bool get isSearching => _isSearching;

  bool _hasAccount = false;
  bool get hasAccount => _hasAccount;

  UsersList _usersList;
  UsersList get usersList => _usersList;

  set usersList(val) {
    _usersList = val;
    notifyListeners();
  }

  set hasAccount(val) {
    _hasAccount = val;
    notifyListeners();
  }

  set contacts(List<Contact> val) {
    _contacts = val;
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set isSearching(val) {
    _isSearching = val;
    notifyListeners();
  }

  loadData(context) async {
    try {
      var userContact = await ContactsService.getContacts();
      _isLoading = false;

      if (userContact != null) _contacts = userContact.toList();
      _contacts.sort((n, m) {
        if (n?.displayName != null)
          return n?.displayName?.compareTo(m?.displayName ?? '');
        else {
          return 1;
        }
      });

      _usersList = await UserListLoad.getAllChats(context);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      // Handle error...
    }
  }

  void inviteDesicion(int index, BuildContext context) async {
    String phone;

    if (contacts[index].phones.toList().length == 1) {
      phone = contacts[index].phones.toList()[0].value;
    } else if (contacts[index].phones.toList().length > 1) {
      phone = contacts[index]?.phones?.toList()[1].value;
    } else {
      phone = '';
    }
    
    var profileData = await getProfileData();

    for (var item in _usersList?.data) {
      if (item.phone.replaceAll(' ', '') == phone.replaceAll(' ', '')) {
        hasAccount = true;
        notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new ChatScreen(
              contact: item,
              getProfileData: profileData,
            ),
          ),
        );
      }
    }
  }

  clearText() {
    searchTEC.text = null;
    _isSearching = false;
    notifyListeners();
  }
}
