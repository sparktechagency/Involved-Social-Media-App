import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';
import '../helpers/prefs_helpers.dart';
import '../helpers/route.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class AuthController extends GetxController {
  //================================> Sign Up <=================================
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  var signUpLoading = false.obs;
  var token = "";

  handleSignUp() async {
    signUpLoading(true);
    Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "password": passwordCtrl.text,
      "phone": phoneNumberCtrl.text.trim(),
      //"fcmToken": "fcmToken..",

    };

    var headers = {'Content-Type': 'application/json'};

    Response response = await ApiClient.postData(
        ApiConstants.signUpEndPoint, jsonEncode(body),
        headers: headers);
    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.toNamed(AppRoutes.otpScreen, parameters: {
        "email": emailCtrl.text.trim(),
        "screenType": "signup",
      });
      nameCtrl.clear();
      emailCtrl.clear();
      passwordCtrl.clear();
      phoneNumberCtrl.clear();
      signUpLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      Fluttertoast.showToast(msg: response.statusText ?? "");
      signUpLoading(false);
      update();
    }
  }


  //===================> Otp very <=======================
  TextEditingController otpCtrl = TextEditingController();
  var otpLoading = false.obs;
  handleOtpVery(
      {required String email,
        required String otp,
        required String screenType}) async {
    try {
      var body = {'oneTimeCode': otpCtrl.text, 'email': email};
      var headers = {'Content-Type': 'application/json'};
      otpLoading(true);
      Response response = await ApiClient.postData(
          ApiConstants.otpVerifyEndPoint, jsonEncode(body),
          headers: headers);
      print("============${response.body} and ${response.statusCode}");
      if (response.statusCode == 200) {
        otpCtrl.clear();
        if (screenType == "forgetPasswordScreen") {
          Get.offAllNamed(
            AppRoutes.resetPasswordScreen,
            parameters: {"email": email},
          );
        } else {
          // After successful OTP verification for signup, redirect to sign in screen
          // The sign in screen will then redirect to update profile screen
          Get.offAllNamed(AppRoutes.signInScreen, parameters: {"email": email});
        }
      } else {
        ApiChecker.checkApi(response);
        Fluttertoast.showToast(msg: response.statusText ?? "");
      }
    } catch (e, s) {
      print("===> e : $e");
      print("===> s : $s");
    }
    otpLoading(false);
  }

  //=================> Resend otp <=====================
  var resendOtpLoading = false.obs;
  resendOtp(String email) async {
    resendOtpLoading(true);
    var body = {"email": email};
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.forgotPassEndPoint, json.encode(body),
        headers: header);
    print("===> ${response.body}");
    if (response.statusCode == 200) {
    } else {
      Fluttertoast.showToast(
          msg: response.statusText ?? "",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    }
    resendOtpLoading(false);
  }

  //==================================> Sign In <================================
  TextEditingController signInEmailCtrl = TextEditingController();
  TextEditingController signInPassCtrl = TextEditingController();
  var signInLoading = false.obs;

  handleSignIn() async {
    signInLoading(true);
    var headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'email': signInEmailCtrl.text.trim(),
      'password': signInPassCtrl.text.trim(),
      "fcmToken": "fcmToken..",
    };
    Response response = await ApiClient.postData(
        ApiConstants.signInEndPoint, json.encode(body),
        headers: headers);
    print("====> ${response.body}");
    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken,
          response.body['tokens']['accessToken']);
      await PrefsHelper.setString(AppConstants.userId, response.body['data']['_id']);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
        Get.offAllNamed(AppRoutes.homeScreen);
      signInEmailCtrl.clear();
      signInPassCtrl.clear();
      signInLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      Fluttertoast.showToast(msg: response.statusText ?? "");
    }
    signInLoading(false);
  }



  //====================> Forgot pass word <=====================
  TextEditingController forgetEmailTextCtrl = TextEditingController();
  var forgotLoading = false.obs;

  handleForget() async {
    forgotLoading(true);
    var body = {
      "email": forgetEmailTextCtrl.text.trim(),
    };
    var headers = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.forgotPassEndPoint, json.encode(body),
        headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(AppRoutes.otpScreen, parameters: {
        "email": forgetEmailTextCtrl.text.trim(),
        "screenType": "forgetPasswordScreen",
      });
      forgetEmailTextCtrl.clear();
    } else {
      ApiChecker.checkApi(response);
      Fluttertoast.showToast(msg: response.statusText ?? "");
    }
    forgotLoading(false);
  }

  //======================> Handle Change password <============================
  var changeLoading = false.obs;
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  handleChangePassword(String oldPassword, String newPassword) async {
    changeLoading(true);
    var bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var body = {"oldPassword": oldPassword, "newPassword": newPassword};
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };

    var response = await ApiClient.postData(
        ApiConstants.changePassEndPoint, json.encode(body),
        headers: headers);
    print("===============> ${response.body}");
    if (response.statusCode == 200) {
      changeLoading(false);
      Fluttertoast.showToast(msg: 'Password chang successfully.' ?? "");
      Get.back();
      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }
    changeLoading(false);
  }

  //=============================> Set New password <===========================
  var resetPasswordLoading = false.obs;
  resetPassword(String email, String password) async {
    print("=======> $email, and $password");
    resetPasswordLoading(true);
    var body = {"email": email, "password": password};
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.resetPassEndPoint, json.encode(body),
        headers: header);
    if (response.statusCode == 200) {
      _showCustomBottomSheet(Get.context!);
    } else {
      debugPrint("error set password ${response.statusText}");
      Fluttertoast.showToast(
        msg: "${response.statusText}",
      );
    }
    resetPasswordLoading(false);
  }


  //===============================> Password Changed! Bottom Sheet <===============================
  _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            border: Border(
              top: BorderSide(width: 2.w, color: AppColors.primaryColor),
            ),
            color: AppColors.whiteColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 44.w),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                SizedBox(
                  width: 50.w,
                  child: Divider(color: AppColors.greyColor, thickness: 5.5),
                ),
                SizedBox(height: 24.h),
                SvgPicture.asset(AppIcons.okay, width: 130.w, height: 130.h),
                SizedBox(height: 24.h),
                CustomText(
                  text: AppStrings.passwordUpdateSuccessfully.tr,
                  maxLine: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                  text: AppStrings.backToSignIn.tr,
                ),
                SizedBox(height: 72.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

  //======================> Google login Info <============================
 /* final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  handleGoogleSignIn(BuildContext context) async {
    await _auth.signOut();
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);

      // Firebase Authentication
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        var fcmToken = await PrefsHelper.getString(AppConstants.fcmToken);
        var bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

        Map<String, dynamic> body = {
          'email': '${user.email}',
          "fcmToken": fcmToken ?? "",
          "loginType": 'google'
        };
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        };
        Response response = await ApiClient.postData(ApiConstants.signInEndPoint, jsonEncode(body), headers: headers);
        print("response on google login :${response.body}");

        if (response.statusCode == 200) {
          await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['attributes']['tokens']['access']['token']);
          await PrefsHelper.setString(AppConstants.userId, response.body['data']['attributes']['user']['id']);
          await PrefsHelper.setString(AppConstants.userName, response.body['data']['attributes']['user']['fullName']);
          bool condition = response.body['data']['attributes']['user']['isProfileCompleted'];

          if(!condition){
            Get.offAllNamed(AppRoutes.uploadPhotosScreen);
          } else {
            await PrefsHelper.setBool(AppConstants.isLogged, true);
            Get.offAllNamed(AppRoutes.homeScreen);
          }
          // Get.offAllNamed(AppRoutes.uploadPhotosScreen);
          update();
        } else {
          ApiChecker.checkApi(response);
          update();
        }
      }
    } else {
      print("Sign in with Google canceled by user.");
    }
  }*/

