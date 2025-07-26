import 'package:flutter/gestures.dart';
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

class SignUpScreen extends StatefulWidget {
   SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameCTRL = TextEditingController();
  final TextEditingController emailCTRL = TextEditingController();
  final TextEditingController phoneNumberCTRL = TextEditingController();
  final TextEditingController passCTRL = TextEditingController();
  bool isChecked = false;

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
                  onTap: (){
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
                  text: AppStrings.signUpWithEmail.tr,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(text: AppStrings.welcomeBack.tr, bottom: 16.h),
                //=======================> User Name Text Field <=================
                CustomTextField(
                  controller: userNameCTRL,
                  labelText: AppStrings.userName.tr,
                  hintText: AppStrings.enterUsername.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.user),
                ),
                SizedBox(height: 16.h),
                //=======================> Email Text Field <=================
                CustomTextField(
                  controller: emailCTRL,
                  labelText: AppStrings.email.tr,
                  hintText: AppStrings.enterEmail.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.mail),
                ),
                SizedBox(height: 16.h),
                //=======================> Phone Number Text Field <=================
                CustomTextField(
                  keyboardType: TextInputType.number,
                  controller: phoneNumberCTRL,
                  labelText: AppStrings.phoneNumber.tr,
                  hintText: AppStrings.enterPhoneNumber.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.call, color: AppColors.primaryColor),
                ),
                SizedBox(height: 16.h),
                //=======================> Password Text Field <=================
                CustomTextField(
                  isPassword: true,
                  controller: passCTRL,
                  labelText: AppStrings.password.tr,
                  hintText: AppStrings.enterPassword.tr,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                ),
                SizedBox(height: 16.h),
                _checkboxSection(),
                SizedBox(height: 16.h),
                //========================> Sign Up Button <==================
                CustomButton(
                  onTap: () {
                    // Get.offAllNamed(AppRoutes.selectRoleScreen);
                  },
                  text: AppStrings.signUp.tr,
                ),
                SizedBox(height: 16.h),
                //========================> Already have an account Sign Up Button <==================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: AppStrings.alreadyHaveAccount.tr),
                    SizedBox(width: 4.w),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.signInScreen);
                      },
                      child: CustomText(
                        text: AppStrings.signIn.tr,
                        fontWeight: FontWeight.w600,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                //=======================> Or  <=====================
                Center(
                  child: CustomText(
                    text: 'OR'.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    bottom: 8.h,
                  ),
                ),
                //=======================> Google and Facebook Button <=====================
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                width: 1.w, color: AppColors.primaryColor)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.googleLogo, width: 24.w, height: 24.h),
                              SizedBox(width: 12.w),
                              CustomText(
                                text: AppStrings.signUpWithGoogle.tr,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 32.h)
              ],
            ),
          ),
        ),
      ),
    );
  }


  //==========================> Checkbox Section Widget <=======================
  _checkboxSection() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: AppColors.primaryColor,
          focusColor: AppColors.greyColor,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          side: BorderSide(
            color: isChecked ? AppColors.primaryColor : AppColors.primaryColor,
            width: 1.w,
          ),
        ),
        Text.rich(
          maxLines: 3,
          TextSpan(
            text: AppStrings.byCreatingAnAccount.tr,
            style: TextStyle(fontSize: 12.w, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: AppStrings.termsConditions.tr,
                style: TextStyle(fontSize: 12.w, fontWeight: FontWeight.bold),
                recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    //Get.toNamed(AppRoutes.termsConditionScreen);
                  },
              ),
              const TextSpan(text: ' & '),
              TextSpan(
                text: AppStrings.privacyPolicy.tr,
                style: TextStyle(fontSize: 12.w, fontWeight: FontWeight.bold),
                recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    //Get.toNamed(AppRoutes.privacyPolicyScreen);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
