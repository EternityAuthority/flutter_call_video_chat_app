class MarkAsReadModel {
  bool error;
  String msg;
  Data data;

  MarkAsReadModel({this.error, this.msg, this.data});

  MarkAsReadModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  int userId;
  String title;
  String content;
  var isForAdmin;
  String type;
  var isRead;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.title,
      this.content,
      this.isForAdmin,
      this.type,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    isForAdmin = json['is_for_admin'];
    type = json['type'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['is_for_admin'] = this.isForAdmin;
    data['type'] = this.type;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}