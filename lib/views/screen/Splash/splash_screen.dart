import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_images.dart';
import '../../../helpers/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
    /*var isLogged = await PrefsHelper.getBool(AppConstants.isLogged);
      if (isLogged == true) {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }*/

      Get.offAllNamed(AppRoutes.getStartScreen);
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF8EB),
      body: Center(
        child: Image.asset(AppImages.appLogo, width: 250.w, height: 250.h),
      ),
    );
  }
}
