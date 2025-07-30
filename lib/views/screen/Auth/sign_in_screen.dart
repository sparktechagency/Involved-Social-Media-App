import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_background.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController emailCTRL = TextEditingController();
  final TextEditingController passCTRL = TextEditingController();

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
                SizedBox(height: 124.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    AppImages.roundLogo,
                    width: 84.w,
                    height: 84.h,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomText(
                  text: AppStrings.signInToYourAccount.tr,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(text: AppStrings.welcomeBack.tr, bottom: 32.h),
                //=======================> Email Text Field <=================
                CustomTextField(
                  controller: emailCTRL,
                  labelText: AppStrings.email.tr,
                  hintText: AppStrings.enterEmail.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.mail),
                ),
                SizedBox(height: 24.h),
                //=======================> Email Text Field <=================
                CustomTextField(
                  isPassword: true,
                  controller: passCTRL,
                  labelText: AppStrings.password.tr,
                  hintText: AppStrings.enterPassword.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                ),
                //========================> Forgot Passwords Button <==================
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.forgotPasswordScreen);
                    },
                    child: CustomText(
                      text: AppStrings.forgotPasswords.tr,
                      fontWeight: FontWeight.w500,
                      bottom: 32.h,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ),
                //========================> Sign in Button <==================
                CustomButton(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.homeScreen);
                  },
                  text: AppStrings.signIn.tr,
                ),
                SizedBox(height: 32.h),
                //========================> Don’t have an account Sign Up Button <==================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: AppStrings.donotHaveAnAccount.tr),
                    SizedBox(width: 4.w),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.signUpScreen);
                      },
                      child: CustomText(
                        text: AppStrings.signUp.tr,
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
