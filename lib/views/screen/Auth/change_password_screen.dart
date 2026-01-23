import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/auth_controller.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text_field.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.changePassword.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                //==========================> Current password Text Field <===================
                CustomTextField(
                  isPassword: true,
                  controller: authController.oldPasswordCtrl,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                  labelText: AppStrings.oldPassword.tr,
                  hintText: AppStrings.enterPassword.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //==========================> New password Text Field <===================
                CustomTextField(
                  isPassword: true,
                  controller: authController.newPasswordCtrl,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                  labelText: AppStrings.newPassword.tr,
                  hintText: AppStrings.enterPassword.tr,
                  validator: (value) {
                    if (value == null) {
                      return "Please set new password";
                    } else if (value.length < 8 || !_validatePassword(value)) {
                      return "Password: 8 characters min, letters & digits \nrequired";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //==========================> Confirm Password Text Field <===================
                CustomTextField(
                  isPassword: true,
                  controller: authController.confirmPassController,
                  prefixIcon: SvgPicture.asset(AppIcons.lock),
                  labelText: AppStrings.confirmPassword.tr,
                  hintText: AppStrings.enterPassword.tr,
                  validator: (value) {
                    if (value == null) {
                      return "Please re-enter new password";
                    } else if (value != authController.newPasswordCtrl.text) {
                      return "Passwords do not WhatAMatch";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 424.h),
                //==========================> Update Password Button <=======================
                Obx(()=> CustomButton(
                      loading: authController.changeLoading.value,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.handleChangePassword(
                            authController.oldPasswordCtrl.text,
                            authController.newPasswordCtrl.text,
                          );
                        }
                      },
                      text: AppStrings.changePassword.tr),
                ),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool _validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }
}
