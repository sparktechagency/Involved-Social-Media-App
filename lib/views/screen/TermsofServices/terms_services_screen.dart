import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class TermsServicesScreen extends StatelessWidget {
  const TermsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.termsConditions.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              CustomText(
                text:
                    'Lorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu.',
                fontSize: 14.sp,
                maxLine: 20,
                textAlign: TextAlign.start,
                bottom: 24.h,
              ),
              CustomText(
                text:
                    'Lorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu.',
                fontSize: 14.sp,
                maxLine: 20,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
