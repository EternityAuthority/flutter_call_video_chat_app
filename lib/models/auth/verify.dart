class VerifyModel {
  bool error;
  var errorCode;
  String msg;
  String token;
  Data data;

  VerifyModel({this.error, this.errorCode, this.msg, this.token, this.data});

  VerifyModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['error_code'];
    msg = json['msg'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_code'] = this.errorCode;
    data['msg'] = this.msg;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String userId;
  String fullName;
  String phone;
  var profilePic;
  var email;
  var emailVerifiedAt;
  String otp;
  String verifyModelTokenExpiryTime;
  var isAdmin;
  var isVerified;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.fullName,
      this.phone,
      this.profilePic,
      this.email,
      this.emailVerifiedAt,
      this.otp,
      this.verifyModelTokenExpiryTime,
      this.isAdmin,
      this.isVerified,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    phone = json['phone'];
    profilePic = json['profile_pic'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    verifyModelTokenExpiryTime = json['VerifyModel_token_expiry_time'];
    isAdmin = json['is_admin'];
    isVerified = json['is_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['otp'] = this.otp;
    data['VerifyModel_token_expiry_time'] = this.verifyModelTokenExpiryTime;
    data['is_admin'] = this.isAdmin;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
