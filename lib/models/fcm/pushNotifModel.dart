class PushNotif {
  Notification notification;

  PushNotif({this.notification});

  PushNotif.fromMap(Map<dynamic, dynamic> map) {
    notification = map['notification'] != null
        ? new Notification.fromJson(map['notification'])
        : null;
  }

  PushNotif.fromJson(Map<String, dynamic> json) {
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    return data;
  }
}

class Notification {
  String title;
  String body;

  Notification({this.title, this.body});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Notification.fromMap(Map<dynamic, dynamic> map) {
    title = map['title'];
    body = map['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
