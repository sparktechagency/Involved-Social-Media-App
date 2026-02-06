class ApiConstants {
  //=========================>  Local Url <=====================
  static const String baseUrl = "https://d8001.sobhoy.com/api/v1";
  static const String imageBaseUrl = "https://d8001.sobhoy.com/";
  //=========================>  Live Url <=====================
  //static const String baseUrl = "http://192.168.10.160:8080/api/v1";
  //static const String imageBaseUrl = "http://192.168.10.160:8080";

  static const String signUpEndPoint = "/auth/signup";
  static const String signInEndPoint = "/auth/signin";
  static const String otpVerifyEndPoint = "/auth/verify_otp";
  static const String forgotPassEndPoint = "/auth/forgot_password";
  static const String resetPassEndPoint = "/auth/reset_password";
  static const String changePassEndPoint = "/auth/update_password";
  static const String googleSignInEndPoint = "/auth/login_with_oauth";
  static const String updatePictureEndPoint = "/user/update-profile";
  static const String getProfileEndPoint = "/user/self-profile";
  static const String updateProfileEndPoint = "/user/update-profile";
  static const String setLocationEndPoint = "";
  static const String termsConditionEndPoint = "/setting-content/termsAndCondition";
  static const String privacyPolicyEndPoint = "/setting-content/privacyPolicy";
  static const String contactUsEndPoint = "/setting-content/contactUs";
  static const String logOutEndPoint = "/auth/logout";
  static const String eventFields = "/event";
  static const String selfEvent = "/event/self";

}
