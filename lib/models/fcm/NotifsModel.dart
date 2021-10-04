class NotifsModel {
  bool error;
  List<NotifsData> data;

  NotifsModel({this.error, this.data});

  NotifsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = new List<NotifsData>();
      json['data'].forEach((v) {
        data.add(new NotifsData.fromJson(v));
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

class NotifsData {
  int id;
  int userId;
  String title;
  String content;
  var isForAdmin;
  String type;
  var isRead;
  String createdAt;
  String updatedAt;

  NotifsData(
      {this.id,
      this.userId,
      this.title,
      this.content,
      this.isForAdmin,
      this.type,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  NotifsData.fromJson(Map<String, dynamic> json) {
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
