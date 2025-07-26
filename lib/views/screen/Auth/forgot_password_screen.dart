import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_background.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController emailCTRL = TextEditingController();

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
                  text: AppStrings.forgotPassword.tr,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(
                  text: AppStrings.pleaseEnterYourEmail.tr,
                  bottom: 32.h,
                ),
                //=======================> Email Text Field <=================
                CustomTextField(
                  controller: emailCTRL,
                  labelText: AppStrings.email.tr,
                  hintText: AppStrings.enterEmail.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.mail),
                ),
                SizedBox(height: 32.h),
                //========================> Send OTP Button <==================
                CustomButton(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.otpScreen);
                  },
                  text: AppStrings.sendOTP.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
