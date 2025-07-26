import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
  final TextEditingController oldPassCTRL = TextEditingController();
  final TextEditingController passCTRL = TextEditingController();
  final TextEditingController confirmPassCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.changePassword.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              //==========================> Current password Text Field <===================
              CustomTextField(
                isPassword: true,
                controller: oldPassCTRL,
                prefixIcon: SvgPicture.asset(AppIcons.lock),
                labelText: AppStrings.oldPassword.tr,
                hintText: AppStrings.enterPassword.tr,
              ),
              SizedBox(height: 16.h),
              //==========================> New password Text Field <===================
              CustomTextField(
                isPassword: true,
                controller: passCTRL,
                prefixIcon: SvgPicture.asset(AppIcons.lock),
                labelText: AppStrings.newPassword.tr,
                hintText: AppStrings.enterPassword.tr,
              ),
              SizedBox(height: 16.h),
              //==========================> Confirm Password Text Field <===================
              CustomTextField(
                isPassword: true,
                controller: confirmPassCTRL,
                prefixIcon: SvgPicture.asset(AppIcons.lock),
                labelText: AppStrings.confirmPassword.tr,
                hintText: AppStrings.enterPassword.tr,
              ),
              SizedBox(height: 424.h),
              //==========================> Update Password Button <=======================
              CustomButton(onTap: () {}, text: AppStrings.changePassword.tr),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}
