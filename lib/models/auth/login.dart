class LoginModel {
  Success success;
  Data data;

  LoginModel({this.success, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Success {
  String token;

  Success({this.token});

  Success.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int id;
  String userId;
  String fullName;
  String firstName;
  String lastName;
  String phone;
  String profilePic;
  String email;
  String phoneVerifiedAt;
  String otp;
  int isMerchant;
  String merchantName;
  String street;
  String city;
  String state;
  String country;
  String verificationTokenExpiryTime;
  int isAdmin;
  int isVerified;
  var fcmToken;
  String status;
  var deletedAt;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.fullName,
      this.firstName,
      this.lastName,
      this.phone,
      this.profilePic,
      this.email,
      this.phoneVerifiedAt,
      this.otp,
      this.isMerchant,
      this.merchantName,
      this.street,
      this.city,
      this.state,
      this.country,
      this.verificationTokenExpiryTime,
      this.isAdmin,
      this.isVerified,
      this.fcmToken,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    profilePic = json['profile_pic'];
    email = json['email'];
    phoneVerifiedAt = json['phone_verified_at'];
    otp = json['otp'];
    isMerchant = json['is_merchant'];
    merchantName = json['merchant_name'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    verificationTokenExpiryTime = json['verification_token_expiry_time'];
    isAdmin = json['is_admin'];
    isVerified = json['is_verified'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    data['email'] = this.email;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['otp'] = this.otp;
    data['is_merchant'] = this.isMerchant;
    data['merchant_name'] = this.merchantName;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['verification_token_expiry_time'] = this.verificationTokenExpiryTime;
    data['is_admin'] = this.isAdmin;
    data['is_verified'] = this.isVerified;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}