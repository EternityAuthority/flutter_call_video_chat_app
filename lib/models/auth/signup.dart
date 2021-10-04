class SignupModel {
  bool error;
  var errorCode;
  String msg;
  Data data;

  SignupModel({this.error, this.errorCode, this.msg, this.data});

  SignupModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String otp;
  User user;

  Data({this.otp, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String userId;
  String phone;
  String fullName;
  String otp;
  String verificationTokenExpiryTime;
  String updatedAt;
  String createdAt;
  int id;

  User(
      {this.userId,
      this.phone,
      this.fullName,
      this.otp,
      this.verificationTokenExpiryTime,
      this.updatedAt,
      this.createdAt,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    phone = json['phone'];
    fullName = json['full_name'];
    otp = json['otp'];
    verificationTokenExpiryTime = json['verification_token_expiry_time'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['phone'] = this.phone;
    data['full_name'] = this.fullName;
    data['otp'] = this.otp;
    data['verification_token_expiry_time'] = this.verificationTokenExpiryTime;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}