import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/settings_controller.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class TermsServicesScreen extends StatelessWidget {
  const TermsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());

    // Call the API when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.termContent.value == null) {
        controller.getTermsCondition();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.termsConditions.tr),
      body: Obx(() => controller.termsConditionLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    CustomText(
                      text: controller.termContent.value?.data?.content ??
                            'No terms and conditions content available.',
                      fontSize: 14.sp,
                      maxLine: null,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
