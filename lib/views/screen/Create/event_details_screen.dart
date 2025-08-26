import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.eventDetails.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //===========================> Event Image <================
                      CustomNetworkImage(
                        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                        height: 180.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      SizedBox(height: 16.h),
                      //=======================> Title  <====================
                      CustomText(
                        text: 'Virginia philps wine testing',
                        fontSize: 20.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 16.h),
                      //=======================> Title & Date Row <====================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: AppStrings.eventType.tr, fontSize: 12.sp),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: 'Giveaway'.tr,
                                  fontSize: 18.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),

                          /// Time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(text: 'Giveaway Gift Card'.tr, fontSize: 12.sp),
                              SizedBox(height: 4.h),
                              CustomText(
                                text: '\$25 Gift Card'.tr,
                                fontSize: 18.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      //===========================> Description Title <===========================
                      Card(
                        elevation: 1.5,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: AppStrings.description.tr,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                text: "The event is live as soon as it's posted. You can explore various categories and locations, or search by specific names, dates, and more. Whether you're attending a business launch, a community fundraiser, or an influencer meet-up, our platform",
                                maxLine: 20,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      //==================================> Location Info Container <============
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CustomText(
                                text: 'Rampura Town Hall Dhaka Bangladesh',
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                maxLine: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
