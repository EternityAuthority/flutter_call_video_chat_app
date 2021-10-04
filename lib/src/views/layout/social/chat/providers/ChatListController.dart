import 'package:flutter/material.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/src/functions/users/usersList.dart';
import 'package:waya/utils/persistence.dart';

class ChatListController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController filter = new TextEditingController();

  List<User> _listUserContact, _exploreUserContact;
  List<User> get listUserContact => _listUserContact;
  List<User> get exploreUserContact => _exploreUserContact;

  GetProfileData _profileData;
  GetProfileData get profileData => _profileData;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSearching = true;
  bool get isSearching => _isSearching;

  bool _isLoading2 = true;
  bool get isLoading2 => _isLoading2;

  set listUserContact(List<User> val) {
    _listUserContact = val;
    notifyListeners();
  }

  set exploreUserContact(List<User> val) {
    _exploreUserContact = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  set isLoading2(bool val) {
    _isLoading2 = val;
    notifyListeners();
  }

  set isSearching(bool val) {
    _isSearching = val;
    notifyListeners();
  }

  set profileData(val) {
    _profileData = val;
    notifyListeners();
  }

  Future<void> loadData(BuildContext context) async {
    try {
      profileData = await getProfileData();
      var userContact = (await getUsersList())?.data;
      _listUserContact = userContact;
      isLoading = false;

      UsersList usersList = await UserListLoad.getAllChats(context);

      if (usersList != null) _listUserContact = usersList?.data?.toList();
      notifyListeners();

      await saveUsersList(usersList: usersList);
      loadExploreData(context);
    } catch (e) {
      print(e.toString());
      // Handle error...
    }
  }

  Future<void> loadExploreData(BuildContext context) async {
    try {
      UsersList exploreUserList = await UserListLoad.allUsers(context);
      if (exploreUserList != null) {
        _exploreUserContact = exploreUserList.data.toList();
      }
      isLoading2 = false;
      //print(exploreUserList.to);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      // Handle error...
    }
  }
}
