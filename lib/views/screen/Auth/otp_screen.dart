import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/auth_controller.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_background.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_pin_code_text_field.dart';
import 'package:involved/views/base/custom_text.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final AuthController authController;
  late var parameters;
  bool _isNavigating = false;

  int _start = 180;
  Timer _timer = Timer(const Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    parameters = Get.parameters;
    // Check if AuthController is already registered, if not, create a new instance
    if (Get.isRegistered<AuthController>()) {
      authController = Get.find();
    } else {
      authController = Get.put(AuthController());
    }
    startTimer();
    if (Get.arguments != null && Get.arguments['isPassreset'] != null) {
      getResetPass();
    }
  }

  startTimer() {
    print("Start Time$_start");
    print("Start Time$_timer");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool isResetPassword = false;

  void resetTimer() {
    _start = 180;
    startTimer();
  }

  getResetPass() {
    var isResetPass = Get.arguments['isPassreset'];
    if (isResetPass) {
      isResetPassword = isResetPass;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 52.h),
                //=======================> Back Button <=================
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined),
                ),
                SizedBox(height: 48.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    AppImages.roundLogo,
                    width: 84.w,
                    height: 84.h,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: AppStrings.verifyEmail.tr,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(
                  text: AppStrings.pleaseCheckYourEmail.tr,
                  bottom: 32.h,
                ),
                //=======================> Email Text Field <=================
                CustomPinCodeTextField(
                  textEditingController: authController.otpCtrl,
                ),
                SizedBox(height: 16.h),
                //========================> Timer Field <==================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.clock),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: '$timerText sc',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                //========================> Verify Email Button <==================
                Obx(
                  () => CustomButton(
                    loading: authController.otpLoading.value || _isNavigating,
                    onTap: () {
                      if (!authController.otpLoading.value && !_isNavigating) {
                        _isNavigating = true;
                        authController.handleOtpVery(
                          email: "${parameters["email"]}",
                          otp: authController.otpCtrl.text,
                          screenType: "${parameters["screenType"]}",
                        );
                      }
                    },
                    text: AppStrings.verifyEmail.tr,
                  ),
                ),
                SizedBox(height: 32.h),
                //========================> Didn’t receive code Resend it Button <==================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: AppStrings.didnotReceiveCode.tr),
                    SizedBox(width: 4.w),
                    InkWell(
                      onTap: _start == 0
                          ? () {
                              authController.resendOtp(
                                "${parameters["email"]}",
                              );
                              authController.otpCtrl.clear();
                              resetTimer();
                            }
                          : null,
                      child: CustomText(
                        text: AppStrings.resendCode.tr,
                        fontWeight: FontWeight.w600,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
