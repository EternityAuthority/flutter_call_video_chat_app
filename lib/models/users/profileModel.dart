class UserProfileModel {
  bool error;
  Data data;

  UserProfileModel({this.error, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  UserDetails userDetails;
  List<WalletDetails> walletDetails;
  //List<var> userPosts;

  Data({this.userDetails, this.walletDetails});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    if (json['walletDetails'] != null) {
      walletDetails = new List<WalletDetails>();
      json['walletDetails'].forEach((v) {
        walletDetails.add(new WalletDetails.fromJson(v));
      });
    }
    /* if (json['userPosts'] != null) {
      userPosts = new List<var>();
      json['userPosts'].forEach((v) {
        userPosts.add(new var.fromJson(v));
      });
    } */
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails.toJson();
    }
    if (this.walletDetails != null) {
      data['walletDetails'] =
          this.walletDetails.map((v) => v.toJson()).toList();
    }
    /* if (this.userPosts != null) {
      data['userPosts'] = this.userPosts.map((v) => v.toJson()).toList();
    } */
    return data;
  }
}

class UserDetails {
  int id;
  String userId;
  String fullName;
  String firstName;
  String lastName;
  String phone;
  String profilePic;
  String email;
  String phoneVerifiedAt;
  var otp;
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
  String deletedAt;
  String createdAt;
  String updatedAt;

  UserDetails(
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

  UserDetails.fromJson(Map<String, dynamic> json) {
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

class WalletDetails {
  int id;
  int userId;
  int clearedBalance;
  int availableBalance;
  String createdAt;
  String updatedAt;

  WalletDetails(
      {this.id,
      this.userId,
      this.clearedBalance,
      this.availableBalance,
      this.createdAt,
      this.updatedAt});

  WalletDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clearedBalance = json['cleared_balance'];
    availableBalance = json['available_balance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['cleared_balance'] = this.clearedBalance;
    data['available_balance'] = this.availableBalance;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
