class MessageModel {
  bool error;
  Message data;

  MessageModel({this.error, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Message.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Message {
  int conversationId;
  int userId;
  int senderId;
  int receiverId;
  String message;
  String imageUrl;
  String updatedAt;
  String createdAt;
  int id;

  Message(
      {this.conversationId,
      this.userId,
      this.senderId,
      this.receiverId,
      this.message,
      this.imageUrl,
      this.updatedAt,
      this.createdAt,
      this.id});

  Message.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversation_id'];
    userId = json['user_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    imageUrl = json['image_url'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation_id'] = this.conversationId;
    data['user_id'] = this.userId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['image_url'] = this.imageUrl;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}