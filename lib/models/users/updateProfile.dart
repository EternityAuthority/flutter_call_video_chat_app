class UpdateProfileModel {
  bool error;
  String msg;
  Data data;

  UpdateProfileModel({this.error, this.msg, this.data});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
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
  String userId;
  String fullName;
  String phone;
  String profilePic;
  var isMerchant;
  String merchantName;
  String street;
  String state;
  String country;
  String city;
  String email;
  String phoneVerifiedAt;
  String otp;
  String verificationTokenExpiryTime;
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
      this.isMerchant,
      this.merchantName,
      this.street,
      this.state,
      this.country,
      this.city,
      this.phoneVerifiedAt,
      this.otp,
      this.verificationTokenExpiryTime,
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
    isMerchant = json['is_merchant'];
    merchantName = json['merchant_name'];
    street = json['street'];
    state = json['state'];
    country = json['country'];
    city = json['city'];
    email = json['email'];
    phoneVerifiedAt = json['phone_verified_at'];
    otp = json['otp'];
    verificationTokenExpiryTime = json['verification_token_expiry_time'];
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
    data['is_merchant'] = this.isMerchant;
    data['merchant_name'] = this.merchantName;
    data['street'] = this.street;
    data['state'] = this.state;
    data['country'] = this.country;
    data['city'] = this.city;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['otp'] = this.otp;
    data['verification_token_expiry_time'] = this.verificationTokenExpiryTime;
    data['is_admin'] = this.isAdmin;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
