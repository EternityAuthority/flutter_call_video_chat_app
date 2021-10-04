class WayaAPI {
  static String base = 'http://wayapay.herokuapp.com';
  // 'http://wayapay.herokuapp.com';
  //'http://167.172.198.45'

  static String baseURL = '$base/api/v1.0';

//AUTHORIZATION
  static String login = '$baseURL/user/auth/login';

  static String register = '$baseURL/user/auth/register';

  static String verify = '$baseURL/user/auth/verify_account';

  static String sendOTP = '$baseURL/user/auth/resend_otp';

  static String reset = '$baseURL/user/auth/password/send_reset_link';

//USER MANAGEMENT
  static String getUsers = '$baseURL/user/chat/all_users';

  static String getChats = '$baseURL/user/chat/chat_list';

  static String passwordReset = '$baseURL/user/account/profile/details';

  static String updateProfile = '$baseURL/user/account/profile/update';

  static String changePassword = '$baseURL/user/account/password/update';

  static String getProfileData = '$baseURL/user/account/profile/details';

  static String deleteUserAccount = '$baseURL/user/account/profile/delete';

//CHAT
  static String sendMessage = '$baseURL/user/chat/new_message';

  static String clearChat = '$baseURL/user/chat/clear';

  static String getMessages = '$baseURL/user/chat/view_user_messages';

  static String editMessage = '$baseURL/user/chat/edit';

//SOCIAL

  static String getSocialProfile(id) => '$baseURL/user/social/profile/$id';

  static String getAllPosts = '$baseURL/user/social/posts/all';

  static String getAllMoments = '$baseURL/user/social/moments/all';

  static String createPost = '$baseURL/user/social/posts/create';

  static String repost = '$baseURL/user/social/posts/repost';

  static String getAllLikes = '$baseURL/user/social/posts/likes/all';

  static String likePost = '$baseURL/user/social/posts/like';

  static String unlikePost = '$baseURL/user/social/posts/unlike';

  static String comment = '$baseURL/user/social/posts/comments/create';

  static String allComments = '$baseURL/user/social/posts/comments/all';

  static String getPostDetails(id) => '$baseURL/user/social/posts/$id/details';

  static String deletePost = '$baseURL/user/social/posts/delete';

  static String deleteComment = '$baseURL/user/social/posts/comments/delete';

  static String invite = '$baseURL/user/social/contact/sms/invite';

  static String emailInvite = '$baseURL/user/social/contact/email/invite';

//CARD MANAGEMENT
  static String editCardData = '$baseURL/user/card/edit_card';

  static String getCardList = '$baseURL/user/card/get_cards';

  static String addCard = '$baseURL/user/card/add_card';

  static String chargeCard = '$baseURL/user/card/charge';

  static String cardValidateAndCharge =
      '$baseURL/user/card/validate_and_charge';

  static String submitPIN = '$baseURL/user/card/submit_pin';

  static String submitOTP = '$baseURL/user/card/submit_otp';

  static String deleteCard = '$baseURL/user/card/remove_card';

  static String resolveBin = '$baseURL/user/card/resolve/bin';

//TRANSACTIONS
  static String accountTopUp = '$baseURL/user/wallet/top_up';

  static String getBalance = '$baseURL/user/wallet/balance';

  static String withdrawToBank = '$baseURL/user/wallet/withdraw';

  static String transferToUser = '$baseURL/user/wallet/send';

  static String transferToUnregistered =
      '$baseURL/user/wallet/send_to_unregistered';

  static String history = '$baseURL/user/wallet/history';

  static String generateTransactionHistory = '$baseURL/user/wallet/generate';

  static String retrievePayment = '$baseURL/user/wallet/retrieve_payment';

  static String addBankAccount = '$baseURL/user/account/add';

  static String getBankAccount = '$baseURL/user/account/all';

  static String setUpBankAccount = '$baseURL/user/account/setup';

  static String deleteBankAccount = '$baseURL/user/account/setup/remove';

  static String sendPaymentRequest = '$baseURL/user/payment-request/new';

  static String getPaymentRequest = '$baseURL/user/payment-request/all';

  static String settlePaymentRequest = '$baseURL/user/payment-request/settle';

  static String rejectPaymentRequest = '$baseURL/user/payment-request/reject';

  //MERCHANT
  static String airtimeTopUp = '$baseURL/user/merchant/topup/airtime';

  static String dataTopUp = '$baseURL/user/merchant/topup/data';

  static String startimes = '$baseURL/user/merchant/startimes/recharge';

  static String multichoiceSubcriptions =
      '$baseURL/user/merchant/multichoice/product_options';

  static String multichoiceRecharge =
      '$baseURL/user/merchant/multichoice/recharge';

  //CLOUD MESSAGING
  static String fcmToken = '$baseURL/user/fcm/update_token';

  static String callUser = '$baseURL/user/fcm/call';

  static String allNotifs = '$baseURL/user/notification/all';

  static String allRead = '$baseURL/user/notification/read';

  static String allUnread = '$baseURL/user/notification/unread';

  static String markRead = '$baseURL/user/notification/mark_as_read';
}

class FireStoreUrl {
  static String fileIcon =
      'https://firebasestorage.googleapis.com/v0/b/waya-paychat.appspot.com/o/fileIcon.png?alt=media&token=7c009438-3229-49ce-b05a-8719d30186c6';
}
