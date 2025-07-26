import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_background.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final TextEditingController passCTRL = TextEditingController();
  final TextEditingController confirmPassCTRL = TextEditingController();

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
                  text: AppStrings.enterNewPassword.tr,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(text: AppStrings.enterANewPassword.tr, bottom: 32.h),
                //=======================> Password Field <=================
                CustomTextField(
                  isPassword: true,
                  controller: passCTRL,
                  labelText: AppStrings.password.tr,
                  hintText: AppStrings.enterPassword.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                ),
                SizedBox(height: 24.h),
                //=======================> Password Field <=================
                CustomTextField(
                  isPassword: true,
                  controller: confirmPassCTRL,
                  labelText: AppStrings.confirmPassword.tr,
                  hintText: AppStrings.enterPassword.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                ),
                SizedBox(height: 32.h),
                //========================> Send OTP Button <==================
                CustomButton(
                  onTap: () {
                    _showCustomBottomSheet(context);
                  },
                  text: AppStrings.save.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                CustomText(text: AppStrings.returnToTheLogin.tr, maxLine: 5),
                SizedBox(height: 24.h),
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                  text: AppStrings.backToSignIn.tr,
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
