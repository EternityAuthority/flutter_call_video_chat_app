class MessageList {
  bool error;
  List<MessageItemModel> data;

  MessageList({this.error, this.data});

  MessageList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = new List<MessageItemModel>();
      json['data'].forEach((v) {
        data.add(new MessageItemModel.fromJson(v));
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

class MessageItemModel {
  int id;
  int userId;
  int conversationId;
  int senderId;
  int receiverId;
  String message;
  String createdAt;
  String updatedAt;
  var imageUrl;
  bool isLoading;
  double percent;

  MessageItemModel(
      {this.id,
      this.userId,
      this.senderId,
      this.receiverId,
      this.message,
      this.createdAt,
      this.conversationId,
      this.percent,
      this.isLoading = false,
      this.updatedAt, this.imageUrl});

  MessageItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['conversation_id'] = this.conversationId;
    data['message'] = this.message;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['percent'] = this.percent;
    return data;
  }
}
