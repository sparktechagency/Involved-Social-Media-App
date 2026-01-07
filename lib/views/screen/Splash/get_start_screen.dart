import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //=====================> Background Image <======================
          Positioned.fill(
            child: Image.asset(AppImages.getStartBgNew, fit: BoxFit.cover),
          ),
          //=====================> Foreground Card <======================
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //===========> Logo <===============
                  Image.asset(AppImages.logoWithText, height: 54.h, width: 150.w),
                  SizedBox(height: 24.h),
                  //==================> Get Started Button <==================
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.signInScreen);
                    },
                    text: AppStrings.getStarted.tr,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
