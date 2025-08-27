import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class EventDetailsScreen extends StatelessWidget {
   EventDetailsScreen({super.key});

  List<String> atmosphereList = [
    "Casual",
    "Romantic",
    "Formal",
    "Party",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.eventDetails.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SingleChildScrollView(
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
                    //===========================> Occurrence Type & Category Card <===========================
                    Card(
                      elevation: 1.5,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: AppStrings.occurrenceType.tr,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                CustomText(
                                  text: 'One Time Event'.tr,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  fontSize: 16.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: double.infinity,
                            child: Divider(
                              thickness: 0.5,
                              color: AppColors.greyColor,
                            ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: AppStrings.eventCategories.tr,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                CustomText(
                                  text: 'Book Club'.tr,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  fontSize: 16.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    //===========================> Event Address & Date Card <===========================
                    Card(
                      elevation: 1.5,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppStrings.eventLocation.tr,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.location),
                                SizedBox(width: 8.h),
                                CustomText(
                                  text: 'Rampura Dhaka, Bangladesh'.tr,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: AppStrings.eventTime.tr,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.clock),
                                SizedBox(width: 8.h),
                                CustomText(
                                  text: 'Jun 17, 2025  09:31AM'.tr,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    //===========================> Description Card <===========================
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
                    //===========================> Atmosphere Card <===========================
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 1.5,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Atmosphere'.tr,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                              ),
                              SizedBox(height: 8.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: List.generate(atmosphereList.length, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: Color(0xffFFEFD1),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                      child: CustomText(
                                        text: atmosphereList[index],
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    //==================================> Event Host Container <============
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
                          CustomNetworkImage(
                              imageUrl: 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                              boxShape: BoxShape.circle,
                              height: 48.h, width: 48.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Bashar Islam',
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  maxLine: 3,
                                  textAlign: TextAlign.start,
                                  bottom: 5.h,
                                ),
                                CustomText(
                                  text: 'Event Host'.tr,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    //===========================> Interested Button <===================
                    CustomButton(onTap: (){}, text: AppStrings.interested.tr),
                    SizedBox(height: 16.h),
                    //===========================> Going Button <===================
                    CustomButton(
                        onTap: (){},
                        color: Colors.white,
                        textColor: AppColors.primaryColor,
                        text: AppStrings.going.tr),
                    SizedBox(height: 16.h),
                    //===========================> Add Button <===================
                    CustomButton(
                        onTap: (){},
                        color: Colors.white,
                        textColor: AppColors.primaryColor,
                        text: AppStrings.add.tr),
                    SizedBox(height: 32.h),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
