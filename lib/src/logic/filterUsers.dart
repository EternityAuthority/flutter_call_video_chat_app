
import 'package:contacts_service/contacts_service.dart';
import 'package:waya/models/chat/allMessages.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/persistence.dart';

Future<List<UserContact>> filterUsers(
    UsersList usersList, List<Contact> contacts) async {
  List<UserContact> tempp = [];
  List<String> numbers = [];
  try {
    for (var i = 0; i < contacts.length; i++) {
      for (var contact in contacts[i]?.phones?.toList()) {
        if (contact.value.trim().substring(0, 3) == '081' ||
            contact.value.replaceAll(' ', "").toString().substring(0, 3) ==
                '080' ||
            contact.value.replaceAll(' ', "").toString().substring(0, 3) ==
                '070' ||
            contact.value.replaceAll(' ', "").toString().substring(0, 3) ==
                '090') {
          /*  print(
              '+234${contact.value.replaceAll(' ', "").split('').sublist(1).join()}');
 */
          for (User user in usersList.data) {
            if (user.phone ==
                '+234${contact.value.replaceAll(' ', "").split('').sublist(1).join()}') {
              //   print(user.phone);

              numbers.add(user.phone);

              tempp.add(UserContact(
                  name: contacts[i].displayName,
                  phone: user.phone,
                  recieverID: user.id,
                  lastMessage: user.lastMessage,
                  avatar: contacts[i].avatar,
                  initials: contacts[i].initials()));
            }
          }
        } else if (contact.value.replaceAll(' ', "").substring(0, 3) == '234') {
          print('+${contact.value}');
          for (User user in usersList.data) {
            if (user.phone ==
                '+${contact.value.replaceAll(' ', "").toString()}') {
              if (numbers.contains('${user.phone}') == false) {
                numbers.add(user.phone);
                //print(user.toJson());
                tempp.add(UserContact(
                    name: contacts[i].displayName,
                    recieverID: user.id,
                    phone: user.phone,
                    lastMessage: user.lastMessage,
                    avatar: contacts[i].avatar,
                    initials: contacts[i].initials()));
              } else {
                // print(tempp);
              }
            }
          }
        } else if (contact.value.replaceAll(' ', "").substring(0, 3) == '+23') {
          // print('${contact.value.replaceAll(' ', "")}');
          for (User user in usersList.data) {
            //   print(user.toJson());
            if (user.phone ==
                '${contact.value.replaceAll(' ', "").toString()}') {
              if (numbers.contains('${user.phone}') == false) {
                numbers.add(user.phone);
                tempp.add(UserContact(
                    name: contacts[i].displayName,
                    recieverID: user.id,
                    phone: user.phone,
                    lastMessage: user.lastMessage,
                    avatar: contacts[i].avatar,
                    initials: contacts[i].initials()));
              } else {
                //  print(tempp);
              }
            }
          }
        }
      }
    }
  } catch (e) {
    print(e.toString());
  }

  saveFilteredUserListData(
      filteredUserList: FilteredUserList(data: tempp.toList()));

  return tempp.toList();
}
