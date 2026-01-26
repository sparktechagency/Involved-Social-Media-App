import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final List<String> interests = [
    'Reading',
    'Photography',
    'Gaming',
    'Music',
    'Travel',
    'Painting',
    'Politics',
    'Charity',
    'Cooking',
    'Pets',
    'Fashion',
    'Sports',
  ];

  final List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Choose your interests'.tr,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 24.h),
              //==============================> Interests Grid <=========================
              Expanded(
                child: Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  alignment: WrapAlignment.start,
                  children: interests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedInterests.remove(interest);
                          } else {
                            _selectedInterests.add(interest);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: CustomText(
                         text: interest,
                            color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24.h),
              //==================================> Finish Button <=============================
              CustomButton(onTap: (){
                debugPrint('Selected: $_selectedInterests');
              }, text: 'Finish'.tr),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}
