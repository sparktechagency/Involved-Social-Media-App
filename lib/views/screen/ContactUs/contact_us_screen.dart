import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import '../../../controller/settings_controller.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());

    // Call the API when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.contactUsContent.value == null) {
        controller.getContactUs();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: 'Contact Us'.tr),
      body: Obx(() => controller.getContactUsLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    CustomText(
                      text: controller.contactUsContent.value?.data?.content ??
                            'No contact us content available.',
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
