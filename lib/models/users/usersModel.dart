class UsersList {
  bool error;
  List<User> data;

  UsersList({this.error, this.data});

  UsersList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String phone;
  int id, conversationId;
  String fullName;
  String userId;
  String lastMessage;
  String amount, trxnRef;

  User({this.phone, this.id,this.conversationId, this.fullName, this.lastMessage, this.amount, this.trxnRef});

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    id = json['id'];
    conversationId = json['conversation_id'];
    fullName = json['full_name'];
    //userId = json['user_id'];
    lastMessage = json['last_message'];
    amount = json['amount'];
    trxnRef = json['trxnRef'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['id'] = this.id;
   // data['user_id'] = this.userId;
    data['conversation_id'] = this.conversationId;
    data['full_name'] = this.fullName;
    data['last_message'] = this.lastMessage;
    data['amount'] = this.amount;
    data['trxnRef'] = this.trxnRef;
    return data;
  }
}