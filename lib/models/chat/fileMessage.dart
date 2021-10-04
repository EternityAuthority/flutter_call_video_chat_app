class FileMessage {
  String type;
  String thumbnailUrl;
  String fileUrl;

  FileMessage({this.type, this.thumbnailUrl, this.fileUrl});

  FileMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    thumbnailUrl = json['thumbnailUrl'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}