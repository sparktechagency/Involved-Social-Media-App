import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/auth_controller.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_background.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passCTRL = TextEditingController();
  final TextEditingController confirmPassCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  //=======================> Password Field <=================
                  CustomTextField(
                    isPassword: true,
                    controller: confirmPassCTRL,
                    labelText: AppStrings.confirmPassword.tr,
                    hintText: AppStrings.enterPassword.tr,
                    prefixIcon: SvgPicture.asset(AppIcons.lock),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter confirm password".tr;
                      } else if (passCTRL.text !=
                          confirmPassCTRL.text) {
                        return "Password doesn't match".tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  //========================> Send OTP Button <==================
                  Obx(()=> CustomButton(
                      loading: authController.resetPasswordLoading.value,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.resetPassword(
                            '${Get.parameters['email']}',
                            confirmPassCTRL.text,
                          );
                        }
                      },
                      text: AppStrings.save.tr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
